import Combine
import PhotosUI
import SwiftUI

@MainActor
final class TemplatePreviewViewModel: ObservableObject {
    enum PhotoState: Equatable {
        case empty
        case loading
        case ready(UIImage)
    }

    enum Option {
        case format
        case quality
    }

    @Published var currentIndex: Int
    @Published private(set) var photo: PhotoState = .empty
    @Published private(set) var format: VideoFormat = .landscape
    @Published private(set) var quality = ""
    @Published var openOption: Option?
    @Published var toast: Toast?
    @Published var isPaywallPresented = false

    let templates: [VideoTemplate]

    private let generationManager: VideoGenerationManager
    private let subscriptionService: SubscriptionService
    private let preferredQuality = "1080p"
    private var imageData: Data?

    init(
        templates: [VideoTemplate],
        selectedTemplateID: Int,
        generationManager: VideoGenerationManager,
        subscriptionService: SubscriptionService
    ) {
        self.templates = templates
        self.generationManager = generationManager
        self.subscriptionService = subscriptionService
        currentIndex = templates.firstIndex { $0.id == selectedTemplateID } ?? 0
        quality = defaultQuality()
    }

    var template: VideoTemplate? {
        templates.indices.contains(currentIndex) ? templates[currentIndex] : nil
    }

    var qualities: [String] {
        template?.qualities ?? []
    }

    var canCreate: Bool {
        if case .ready = photo { template != nil } else { false }
    }

    func templateChanged() {
        if !qualities.contains(quality) {
            quality = defaultQuality()
        }
    }

    func toggle(_ option: Option) {
        openOption = openOption == option ? nil : option
    }

    func select(_ format: VideoFormat) {
        self.format = format
        openOption = nil
    }

    func select(quality: String) {
        self.quality = quality
        openOption = nil
    }

    func loadPhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        photo = .loading
        guard let data = try? await item.loadTransferable(type: Data.self),
              let prepared = await ImagePreparation.prepare(data) else {
            photo = .empty
            toast = Toast(style: .error, title: "Upload failed")
            return
        }
        imageData = prepared.jpeg
        photo = .ready(prepared.image)
    }

    func removePhoto() {
        imageData = nil
        photo = .empty
    }

    func create() -> VideoGeneration? {
        guard let template, let imageData else { return nil }
        guard subscriptionService.isPremium else {
            isPaywallPresented = true
            return nil
        }
        do {
            return try generationManager.start(template: template, image: imageData, format: format, quality: quality)
        } catch {
            toast = Toast(style: .error, title: "Couldn't start generation")
            return nil
        }
    }

    private func defaultQuality() -> String {
        qualities.contains(preferredQuality) ? preferredQuality : qualities.last ?? ""
    }
}
