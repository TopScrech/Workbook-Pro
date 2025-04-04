import SwiftUI

// UIColor -> Hex for better readability
extension UIColor {
    func hexString() -> String {
        let components = self.cgColor.components ?? [0, 0, 0]
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)
        )
    }
}
