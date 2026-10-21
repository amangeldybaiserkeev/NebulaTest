import XCTest
@testable import NebulaTest

@MainActor
final class TemplateCatalogTests: XCTestCase {
    private let api = MockVideoAPI()

    func testLoadGroupsCategoriesInCatalogOrder() async {
        api.templatesResult = .success([
            .stub(id: 1, category: "📈 Trending"),
            .stub(id: 2, category: "💃 Dance"),
            .stub(id: 3, category: "📈 Trending")
        ])
        let catalog = TemplateCatalog(api: api)

        await catalog.load()

        XCTAssertEqual(catalog.categories, ["📈 Trending", "💃 Dance"])
        XCTAssertEqual(catalog.templates(in: "📈 Trending").map(\.id), [1, 3])
        XCTAssertEqual(catalog.template(id: 2)?.category, "💃 Dance")
    }

    func testLoadFailureExposesMessageAndCanRetry() async {
        api.templatesResult = .failure(APIError.server(statusCode: 500))
        let catalog = TemplateCatalog(api: api)

        await catalog.load()
        XCTAssertEqual(catalog.state, .failed(message: APIError.server(statusCode: 500).localizedDescription))

        api.templatesResult = .success([.stub()])
        await catalog.load()
        XCTAssertEqual(catalog.templates.count, 1)
    }
}
