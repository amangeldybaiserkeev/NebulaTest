import SwiftUI

struct TemplatesView: View {
    @StateObject private var viewModel: TemplatesViewModel
    let thumbnailLoader: VideoThumbnailLoader
    let onBack: () -> Void
    let onSelect: (VideoTemplate) -> Void

    private let columns = [GridItem(.flexible(), spacing: Spacing.reg), GridItem(.flexible(), spacing: Spacing.reg)]

    init(
        viewModel: TemplatesViewModel,
        thumbnailLoader: VideoThumbnailLoader,
        onBack: @escaping () -> Void,
        onSelect: @escaping (VideoTemplate) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.thumbnailLoader = thumbnailLoader
        self.onBack = onBack
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(spacing: 0) {
            VideoHeader(onBack: onBack)
            content
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            ErrorStateView(message: message) {
                Task { await viewModel.load() }
            }
        case .loaded:
            VStack(spacing: Spacing.lg) {
                categories
                grid
            }
            .padding(.top, Spacing.lg)
        }
    }

    private var categories: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Spacing.sm) {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryChip(title: category, isSelected: category == viewModel.selectedCategory) {
                        viewModel.selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, Spacing.reg)
        }
        .scrollIndicators(.hidden)
    }

    private var grid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Spacing.reg) {
                ForEach(viewModel.templates) { template in
                    TemplateCard(template: template, thumbnailLoader: thumbnailLoader) {
                        onSelect(template)
                    }
                }
            }
            .padding(.horizontal, Spacing.reg)
            .padding(.bottom, Spacing.reg)
        }
        .scrollIndicators(.hidden)
    }
}
