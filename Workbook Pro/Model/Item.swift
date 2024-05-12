import SwiftUI
import SwiftData

@Model
final class Note {
    var name: String
    var pages: [Data]
    var image: Data? = nil
    var isPinned = false
    let created = Date()
    //    var modified = Date()
    
    //    var background: Color?
    
    init(_ name: String, pages: [Data] = [Data()], image: Data? = nil) {
        self.pages = pages
        self.name = name
        self.image = image
    }
}
