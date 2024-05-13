import PencilKit

class DrawingVM: ObservableObject {
    var vc: DrawingViewController?
    
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
