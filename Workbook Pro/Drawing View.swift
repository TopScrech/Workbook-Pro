import SwiftUI

struct DrawingView: View {
    @ObservedObject private var drawingController = DrawingVM()
    @EnvironmentObject private var storage: Storage
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
            .toolbar(storage.showNavBar ? .visible : .hidden, for: .navigationBar)
            .statusBarHidden(!storage.showStatusBar)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let edgeWidth = 20.0
                        let minimumDragTranslation = 50.0
                        
                        if value.startLocation.x < edgeWidth && value.translation.width > minimumDragTranslation {
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
//      .environmentObject(Storage())
//}
