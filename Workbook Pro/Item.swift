import SwiftUI
import SwiftData

@Model
final class Item {
    var name: String
    var drawing = Data()
    var image: Data?
    
    init(_ name: String) {
        self.name = name
    }
}
