import SwiftUI
import PencilKit

@Observable
final class DrawingVM {
    var vc: DrawingVC?
    
    var toolWidth = 5.0
    
    var isFirstPage: Bool {
        vc?.selectedPage == 0
    }
    
    var isLastPage: Bool {
        if let pages = vc?.note?.pages {
            vc?.selectedPage == pages.count - 1
        } else {
            false
        }
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
