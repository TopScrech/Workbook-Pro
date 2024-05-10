import SwiftUI
import SwiftData

@Model
final class Note {
    var name: String
    var drawing = Data()
    var image: Data?
//    var background: Color?
    
    init(_ name: String) {
        self.name = name
    }
}
