import SwiftUI

struct PencilDoubleTapLogger: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.5, *) {
            content.onPencilDoubleTap {
                let pos = String(describing: $0.hoverPose)
                print("Double tap:", pos)
            }
        } else {
            content
        }
    }
}

struct PencilSqueezeLogger: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.5, *) {
            content.onPencilSqueeze {
                print("Squeeze:", $0)
            }
        } else {
            content
        }
    }
}

extension View {
    func pencilDoubleTapLogging() -> some View {
        modifier(PencilDoubleTapLogger())
    }
    
    func pencilSqueezeLogging() -> some View {
        modifier(PencilSqueezeLogger())
    }
}
