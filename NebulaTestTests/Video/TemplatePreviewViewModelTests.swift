import XCTest
@testable import NebulaTest

@MainActor
final class TemplatePreviewViewModelTests: XCTestCase {
    private let api = MockVideoAPI()
    private let subscriptions = MockSubscriptionService()
    private lazy var manager = VideoGenerationManager(
        api: api,
        store: CoreDataVideoStore(container: PersistenceController(inMemory: true).container)
    )

    private func makeViewModel(templates: [VideoTemplate], selectedID: Int) -> TemplatePreviewViewModel {
        TemplatePreviewViewModel(
            templates: templates,
            selectedTemplateID: selectedID,
            generationManager: manager,
            subscriptionService: subscriptions
        )
    }

    func testSelectsRequestedTemplateAndPreferredQuality() {
        let viewModel = makeViewModel(templates: [.stub(id: 1), .stub(id: 2)], selectedID: 2)

        XCTAssertEqual(viewModel.currentIndex, 1)
        XCTAssertEqual(viewModel.template?.id, 2)
        XCTAssertEqual(viewModel.quality, "1080p")
        XCTAssertEqual(viewModel.format, .landscape)
    }

    func testQualityFallsBackToHighestAvailableWhenTemplateChanges() {
        let templates = [VideoTemplate.stub(id: 1), .stub(id: 2, qualities: ["360p", "540p"])]
        let viewModel = makeViewModel(templates: templates, selectedID: 1)

        viewModel.currentIndex = 1
        viewModel.templateChanged()

        XCTAssertEqual(viewModel.quality, "540p")
    }

    func testCreateIsBlockedWithoutPhoto() {
        let viewModel = makeViewModel(templates: [.stub()], selectedID: 1)

        XCTAssertFalse(viewModel.canCreate)
        XCTAssertNil(viewModel.create())
        XCTAssertTrue(api.startCalls.isEmpty)
    }

    func testToggleOptionOpensAndCloses() {
        let viewModel = makeViewModel(templates: [.stub()], selectedID: 1)

        viewModel.toggle(.format)
        XCTAssertEqual(viewModel.openOption, .format)
        viewModel.select(.square)
        XCTAssertEqual(viewModel.format, .square)
        XCTAssertNil(viewModel.openOption)
    }
}
