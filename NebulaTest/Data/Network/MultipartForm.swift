import Foundation

struct MultipartForm {
    struct File {
        let name: String
        let filename: String
        let mimeType: String
        let data: Data
    }

    var fields: [String: String] = [:]
    var files: [File] = []
    let boundary = "Boundary-\(UUID().uuidString)"

    var contentType: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    func encoded() -> Data {
        var body = Data()
        for (name, value) in fields {
            body.append(line("--\(boundary)"))
            body.append(line("Content-Disposition: form-data; name=\"\(name)\""))
            body.append(line(""))
            body.append(line(value))
        }
        for file in files {
            body.append(line("--\(boundary)"))
            body.append(line("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\""))
            body.append(line("Content-Type: \(file.mimeType)"))
            body.append(line(""))
            body.append(file.data)
            body.append(line(""))
        }
        body.append(line("--\(boundary)--"))
        return body
    }

    private func line(_ string: String) -> Data {
        Data("\(string)\r\n".utf8)
    }
}
