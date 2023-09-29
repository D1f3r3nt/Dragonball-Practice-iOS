import Foundation

struct Transformation: Decodable, Encodable, Equatable {
    let id: String
    let name: String
    let description: String
    let photo: URL
}
