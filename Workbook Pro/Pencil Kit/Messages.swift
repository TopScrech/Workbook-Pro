import Foundation

struct SetupMessage: Codable {
    let id: UUID
}

struct UpdateMessage: Codable {
    let strokes: [Data]
}
