import Foundation

final class PixverseVideoAPI: VideoAPI {
    private let client: HTTPClient
    private let applicationID: String

    init(client: HTTPClient, applicationID: String) {
        self.client = client
        self.applicationID = applicationID
    }

    func templates() async throws -> [VideoTemplate] {
        let response: TemplatesResponseDTO = try await client.send(
            Endpoint(path: "api/v1/get_templates/\(applicationID)")
        )
        return response.templates.compactMap(VideoTemplate.init)
    }

    func startGeneration(templateID: Int, image: Data, quality: String) async throws -> Int {
        var form = MultipartForm()
        form.fields = ["template_id": String(templateID), "quality": quality]
        form.files = [MultipartForm.File(name: "image", filename: "photo.jpg", mimeType: "image/jpeg", data: image)]
        let response: StartGenerationResponseDTO = try await client.send(
            Endpoint(path: "api/v1/template2video", method: .post, body: .multipart(form))
        )
        return response.videoId
    }

    func generationStatus(id: Int) async throws -> GenerationStatus {
        let response: GenerationStatusResponseDTO = try await client.send(
            Endpoint(path: "api/v1/status", query: ["id": String(id)])
        )
        switch response.status {
        case "success":
            guard let string = response.videoUrl, let url = URL(string: string) else { throw APIError.decoding }
            return .success(url)
        case "generating":
            return .generating
        default:
            return .error
        }
    }
}

private extension VideoTemplate {
    init?(_ dto: TemplateDTO) {
        guard dto.isActive, let previewURL = URL(string: dto.previewSmall) else { return nil }
        self.init(
            id: dto.id,
            providerID: dto.templateId,
            name: dto.name,
            category: dto.category,
            qualities: dto.qualities,
            previewURL: previewURL
        )
    }
}
