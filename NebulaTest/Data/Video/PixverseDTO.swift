import Foundation

struct TemplatesResponseDTO: Decodable {
    let templates: [TemplateDTO]
}

struct TemplateDTO: Decodable {
    let id: Int
    let templateId: Int
    let name: String
    let category: String
    let qualities: [String]
    let previewSmall: String
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case templateId = "template_id"
        case name
        case category
        case qualities
        case previewSmall = "preview_small"
        case isActive = "is_active"
    }
}

struct StartGenerationResponseDTO: Decodable {
    let videoId: Int

    enum CodingKeys: String, CodingKey {
        case videoId = "video_id"
    }
}

struct GenerationStatusResponseDTO: Decodable {
    let status: String
    let videoUrl: String?

    enum CodingKeys: String, CodingKey {
        case status
        case videoUrl = "video_url"
    }
}
