import Foundation

enum RequestBody {
    case none
    case json(any Encodable)
    case multipart(MultipartForm)
}
