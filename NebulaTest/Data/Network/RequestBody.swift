import Foundation

enum RequestBody {
    case none
    case json(Encodable)
    case multipart(MultipartForm)
}
