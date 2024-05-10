import SwiftUI
import PencilKit

private final class DrawingManager: ObservableObject {
//private final class DrawingManager: NSObject, ObservableObject, PKCanvasViewDelegate, PKToolPickerObserver, UIScreenshotServiceDelegate {
    let toolPicker = PKToolPicker()
    var canvasView: PKCanvasView?
    
    func register(_ canvasView: PKCanvasView) {
        self.canvasView = canvasView
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
//        updateLayout(for: toolPicker)
        canvasView.becomeFirstResponder()
    }
    
    func unregister() {
        guard let canvasView else {
            return
        }
        
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        toolPicker.removeObserver(canvasView)
        canvasView.resignFirstResponder()
        self.canvasView = nil
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(#function)
        
        //        hasModifiedDrawing = true
//        updateContentSizeForDrawing()
    }
    
    /// Helper method to set a suitable content size for the canvas view
//    func updateContentSizeForDrawing() {
//        guard let canvasView else {
//            return
//        }
//        
//        // Update the content size to match the drawing
//        let drawing = canvasView.drawing
//        let contentHeight: CGFloat
//        
//        // Adjust the content size to always be bigger than the drawing height
//        if !drawing.bounds.isNull {
//            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + canvasOverscrollHeight) * canvasView.zoomScale)
//        } else {
//            contentHeight = canvasView.bounds.height
//        }
//        
//        canvasView.contentSize = CGSize(width: 768 * canvasView.zoomScale, height: 5000)
//        //        canvasView.contentSize = CGSize(width: DataModel.canvasWidth * canvasView.zoomScale, height: contentHeight)
//    }
}

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let canvasOverscrollHeight: CGFloat = 8000
    
    /// Delegate method: Note that the tool picker has changed which part of the canvas view it obscures, if any
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        print(#function)
        
        updateLayout(for: toolPicker)
    }
    
    /// Delegate method: Note that the tool picker has become visible or hidden.
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        print(#function)
        
        updateLayout(for: toolPicker)
    }
    
    func updateLayout(for toolPicker: PKToolPicker) {
        print(#function)
        
        let obscuredFrame = toolPicker.frameObscured(in: canvasView)
        
        // If the tool picker is floating over the canvas, it also contains undo and redo buttons
        if obscuredFrame.isNull {
            canvasView.contentInset = .zero
        } else {
            // Otherwise, the bottom of the canvas should be inset to the top of the
            // tool picker, and the tool picker no longer displays its own undo and redo buttons
            
            canvasView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: canvasView.bounds.maxY - obscuredFrame.minY, right: 0)
        }
        
        canvasView.scrollIndicatorInsets = canvasView.contentInset
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        print(#function)
        
        let drawing = canvasView.drawing
        
        let contentHeight = UIScreen.main.bounds.height + canvasOverscrollHeight
        let contentWidth = UIScreen.main.bounds.width
        
        canvasView.drawingPolicy = .pencilOnly
        canvasView.isScrollEnabled = true
        canvasView.alwaysBounceVertical = true
        
        print("contentHeight: \(contentHeight)")
        print("contentWidth: \(contentWidth)")
        
        canvasView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        print(#function)
        
    }
}

struct ContentView: View {
    @StateObject private var drawingManager = DrawingManager()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.undoManager) private var undoManager
    
    @State private var canvasView = PKCanvasView()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Button("Clear") {
                    canvasView.drawing = PKDrawing()
                }
                
                Button("Undo") {
                    undoManager?.undo()
                }
                
                Button("Redo") {
                    undoManager?.redo()
                }
                
                MyCanvas(canvasView: $canvasView)
            }
            .ignoresSafeArea()
            
        }
        .onAppear {
            drawingManager.register(canvasView)
        }
        .onDisappear {
            drawingManager.unregister()
        }
    }
}

#Preview {
    ContentView()
}
