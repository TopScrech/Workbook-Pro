import SwiftUI
import SwiftData

@Model
final class Note {
    var name: String
    var drawing: Data
    var image: Data? = nil
    var isPinned = false
    
    //    var background: Color?
    
    init(_ name: String, drawing: Data = Data(), image: Data? = nil) {
        self.drawing = drawing
        self.name = name
        self.image = image
    }
}
