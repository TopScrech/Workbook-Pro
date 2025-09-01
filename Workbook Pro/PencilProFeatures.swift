import SwiftUI

struct PencilDoubleTapLogger: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.5, *) {
            content.onPencilDoubleTap { value in
                let pos = String(describing: value.hoverPose)
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
            content.onPencilSqueeze { phase in
                print("Squeeze:", phase)
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
