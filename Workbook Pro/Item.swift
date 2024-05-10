import Foundation
import SwiftData

@Model
final class Item {
    var name: String
    var drawing = Data()
    
    init(_ name: String) {
        self.name = name
    }
}
