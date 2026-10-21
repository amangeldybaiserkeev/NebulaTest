import PhotosUI
import SwiftUI

struct TemplatePreviewView: View {
    @StateObject private var viewModel: TemplatePreviewViewModel
    let container: AppContainer
    let thumbnailLoader: VideoThumbnailLoader
    let onBack: () -> Void
    let onCreated: (VideoGeneration) -> Void

    @State private var pickerItem: PhotosPickerItem?

    private let carouselHeight: Double = 311

    init(
        viewModel: TemplatePreviewViewModel,
        container: AppContainer,
        thumbnailLoader: VideoThumbnailLoader,
        onBack: @escaping () -> Void,
        onCreated: @escaping (VideoGeneration) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
        self.thumbnailLoader = thumbnailLoader
        self.onBack = onBack
        self.onCreated = onCreated
    }

    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(title: viewModel.template?.name, onBack: onBack)

            ScrollView {
                VStack(spacing: 0) {
                    TemplateCarousel(
                        templates: viewModel.templates,
                        currentIndex: $viewModel.currentIndex,
                        loader: thumbnailLoader
                    )
                    .frame(height: carouselHeight)
                    .padding(.top, Spacing.reg)

                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        photoSlot
                        options
                    }
                    .padding(.top, Spacing.lg)
                    .padding(.horizontal, Spacing.reg)
                    .padding(.bottom, Spacing.reg)
                }
            }
            .scrollIndicators(.hidden)

            GradientButton(title: "Create", isEnabled: viewModel.canCreate, action: create)
                .padding(.horizontal, Spacing.reg)
                .padding(.bottom, Spacing.reg)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .overlayPreferenceValue(OptionAnchorKey.self, dropdown)
        .animation(Animations.state, value: viewModel.openOption)
        .toast($viewModel.toast)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: pickerItem) { item in Task { await viewModel.loadPhoto(item) } }
        .onChange(of: viewModel.currentIndex) { _ in viewModel.templateChanged() }
        .fullScreenCover(isPresented: $viewModel.isPaywallPresented) {
            PaywallView(
                viewModel: container.makePaywallViewModel(),
                onClose: { viewModel.isPaywallPresented = false },
                onUnlock: { viewModel.isPaywallPresented = false }
            )
        }
    }

    private var photoSlot: some View {
        let photo = viewModel.photo
        return PhotosPicker(selection: $pickerItem, matching: .images) {
            PhotoSlot(state: photo)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(photo != .empty)
        .overlay(alignment: .topTrailing) {
            if case .ready = photo {
                PhotoRemoveButton(action: removePhoto)
            }
        }
        .animation(Animations.state, value: photo)
    }

    private var options: some View {
        VStack(spacing: Spacing.xs) {
            OptionRow(title: "Format", value: viewModel.format.rawValue, option: .format) {
                viewModel.toggle(.format)
            }
            OptionRow(title: "Quality", value: viewModel.quality, option: .quality) {
                viewModel.toggle(.quality)
            }
        }
    }

    @ViewBuilder
    private func dropdown(anchors: [TemplatePreviewViewModel.Option: Anchor<CGRect>]) -> some View {
        if let option = viewModel.openOption, let anchor = anchors[option] {
            GeometryReader { proxy in
                let frame = proxy[anchor]
                Color.black.opacity(Opacity.invisible)
                    .ignoresSafeArea()
                    .onTapGesture { viewModel.openOption = nil }
                dropdownContent(for: option)
                    .frame(width: frame.maxX, height: frame.maxY, alignment: .bottomTrailing)
                    .transition(.scale(scale: Animations.pressedScale, anchor: .bottomTrailing).combined(with: .opacity))
            }
        }
    }

    @ViewBuilder
    private func dropdownContent(for option: TemplatePreviewViewModel.Option) -> some View {
        switch option {
        case .format:
            OptionDropdown(items: VideoFormat.allCases.map(DropdownItem.init), selectedID: viewModel.format.id) { id in
                VideoFormat(rawValue: id).map(viewModel.select)
            }
        case .quality:
            OptionDropdown(items: viewModel.qualities.map(DropdownItem.init(quality:)), selectedID: viewModel.quality) {
                viewModel.select(quality: $0)
            }
        }
    }

    private func removePhoto() {
        pickerItem = nil
        viewModel.removePhoto()
    }

    private func create() {
        if let generation = viewModel.create() {
            onCreated(generation)
        }
    }
}
