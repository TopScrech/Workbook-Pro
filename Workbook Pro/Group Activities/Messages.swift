import Foundation

struct SetupCommand: Codable {
    let name: String
}

struct UpdateCommand: Codable {
    let strokes: [Data]
}
