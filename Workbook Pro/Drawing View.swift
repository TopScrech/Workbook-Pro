import SwiftUI
import PencilKit

class DrawingController: ObservableObject {
    var vc: DrawingViewController?
    
    func changeToolWidth(to newWidth: CGFloat) {
        vc?.changeToolWidth(to: newWidth)
    }
    
    func clear() {
        vc?.canvasView.drawing = PKDrawing()
    }
    
    func undo() {
        vc?.undoManager?.undo()
    }
    
    func redo() {
        vc?.undoManager?.redo()
    }
}

struct DrawingView: View {
    @ObservedObject private var drawingController = DrawingController()
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    @State private var toolWidth: CGFloat = 5
    
    var body: some View {
        //        Button("dismiss") {
        //            dismiss()
        //        }
        
        DrawingRepresentable(drawingData: $note.drawing, imageData: $note.image, controller: drawingController)
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
            .statusBarHidden(true)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.x < 20 /* edgeWidth */ && value.translation.width > 50 /* minimumDragTranslation */ {
                            dismiss()
                        }
                    }
            )
            .toolbar {
                Menu {
                    Button("Clear") {
                        drawingController.clear()
                    }
                    
                    Button("Undo") {
                        drawingController.undo()
                    }
                    
                    Button("Redo") {
                        drawingController.redo()
                    }
                    
                    Divider()
                    
                    Text(toolWidth)
                    
                    Slider(value: $toolWidth, in: 1...100, step: 0.1)
                        .padding()
                    
                    Button("Set Tool Width") {
                        drawingController.changeToolWidth(to: toolWidth)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
    }
}

//#Preview {
//    DrawingView()
//}
