import SwiftUI
import PencilKit

final class DrawingVM: ObservableObject {
    var vc: DrawingViewController?
    
    @Published var toolWidth = 5.0
    
    var isFirstPage: Bool {
        vc?.selectedPage == 0
    }
    
    var strokes: Int? {
        vc?.canvasView.drawing.strokes.count
    }
    
    func changeToolWidth(to newWidth: CGFloat) {
        vc?.changeToolWidth(to: newWidth)
    }
    
    func clear() {
        vc?.canvasView.drawing = PKDrawing()
    }
    
    func deletePage() {
        vc?.deletePage()
    }
    
    func undo() {
        vc?.undoManager?.undo()
    }
    
    func redo() {
        vc?.undoManager?.redo()
    }
    
    func next() {
        vc?.nextPage()
    }
    
    func previous() {
        vc?.previousPage()
    }
}
