import Foundation

struct SetupMessage: Codable {
    let name: String
}

struct UpdateMessage: Codable {
    let strokes: [Data]
}
