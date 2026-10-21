import XCTest
@testable import NebulaTest

// swiftlint:disable force_unwrapping

final class URLSessionHTTPClientTests: XCTestCase {
    private struct Payload: Decodable, Equatable {
        let value: String
    }

    private let client: URLSessionHTTPClient = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSessionHTTPClient(
            configuration: APIConfiguration(
                baseURL: URL(string: "https://example.com/api")!,
                bearerToken: "token",
                applicationID: "com.test.test",
                userID: { "user-1" }
            ),
            session: URLSession(configuration: configuration)
        )
    }()

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func testRequestCarriesAuthAndIdentityQuery() async throws {
        var captured: URLRequest?
        StubURLProtocol.handler = { request in
            captured = request
            return (Self.response(for: request, status: 200), Data(#"{"value":"ok"}"#.utf8))
        }

        let payload: Payload = try await client.send(Endpoint(path: "chats/1/messages", method: .post))

        XCTAssertEqual(payload, Payload(value: "ok"))
        let url = try XCTUnwrap(captured?.url)
        XCTAssertEqual(url.path, "/api/chats/1/messages")
        XCTAssertEqual(url.query, "app_id=com.test.test&user_id=user-1")
        XCTAssertEqual(captured?.value(forHTTPHeaderField: "Authorization"), "Bearer token")
        XCTAssertEqual(captured?.httpMethod, "POST")
    }

    func testPaymentRequiredMapsToInsufficientCredits() async {
        StubURLProtocol.handler = { request in (Self.response(for: request, status: 402), Data()) }

        await assertThrows(APIError.insufficientCredits) {
            let _: Payload = try await self.client.send(Endpoint(path: "x"))
        }
    }

    func testUnauthorizedMapsToUnauthorized() async {
        StubURLProtocol.handler = { request in (Self.response(for: request, status: 401), Data()) }

        await assertThrows(APIError.unauthorized) {
            let _: Payload = try await self.client.send(Endpoint(path: "x"))
        }
    }

    func testMalformedBodyMapsToDecodingError() async {
        StubURLProtocol.handler = { request in (Self.response(for: request, status: 200), Data("nope".utf8)) }

        await assertThrows(APIError.decoding) {
            let _: Payload = try await self.client.send(Endpoint(path: "x"))
        }
    }

    private func assertThrows(_ expected: APIError, _ operation: () async throws -> Void) async {
        do {
            try await operation()
            XCTFail("Expected \(expected) to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, expected)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    private static func response(for request: URLRequest, status: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
    }
}
// swiftlint:enable force_unwrapping
