import Foundation

protocol HTTPClient: Sendable {
    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response
}

struct APIConfiguration: Sendable {
    let baseURL: URL
    let bearerToken: String
    let applicationID: String
    let userID: @Sendable () -> String
}

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let decoder: JSONDecoder

    init(configuration: APIConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Self.decodeDate)
    }

    func send<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        let request = try makeRequest(for: endpoint)
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.network(error.localizedDescription)
        }
        try validate(response)
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }

    private func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            url: configuration.baseURL.appending(path: endpoint.path),
            resolvingAgainstBaseURL: false
        ) else { throw APIError.invalidURL }

        var query = endpoint.query
        query["user_id"] = configuration.userID()
        query["app_id"] = configuration.applicationID
        components.queryItems = query.sorted { $0.key < $1.key }.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("Bearer \(configuration.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        switch endpoint.body {
        case .none:
            break
        case .json(let value):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(value)
        case .multipart(let form):
            request.setValue(form.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = form.encoded()
        }
        return request
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { throw APIError.decoding }
        switch http.statusCode {
        case HTTPStatus.success: return
        case HTTPStatus.unauthorized, HTTPStatus.forbidden: throw APIError.unauthorized
        case HTTPStatus.paymentRequired: throw APIError.insufficientCredits
        case HTTPStatus.notFound: throw APIError.notFound
        default: throw APIError.server(statusCode: http.statusCode)
        }
    }

    private static func decodeDate(from decoder: Decoder) throws -> Date {
        let string = try decoder.singleValueContainer().decode(String.self)
        let strategy = Date.ISO8601FormatStyle(timeZone: .current)
        if let date = try? Date(string, strategy: strategy) { return date }
        if let date = try? Date(string, strategy: strategy.time(includingFractionalSeconds: true)) { return date }
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported date: \(string)")
        )
    }
}
