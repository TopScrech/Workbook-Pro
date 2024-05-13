import SwiftUI

struct DrawingView: View {
    @StateObject private var drawingController = DrawingVM()
    @EnvironmentObject private var storage: Storage
    @Environment(\.dismiss) private var dismiss
    
    private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    @State private var toolWidth: CGFloat = 5
    
    private var isFirstPage: Bool {
        drawingController.vc?.selectedPage == 0
    }
    
    private var strokes: Int? {
        drawingController.vc?.canvasView.drawing.strokes.count
    }
    
    var body: some View {
        //        Button("dismiss") {
        //            dismiss()
        //        }
        
        DrawingRepresentable(note: note)
            .environmentObject(drawingController)
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
                ToolbarItemGroup(placement: .topBarLeading) {
                    if let selectedPage = drawingController.vc?.selectedPage {
                        Text("Page \(selectedPage + 1) of \(note.pages.count)")
                    }
                    
                    Button("Previous") {
                        drawingController.previous()
                    }
                    .disabled(isFirstPage)
                    
                    Button("Next") {
                        drawingController.next()
                    }
                    
                    Button {
                        drawingController.deletePage()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .disabled(note.pages.count == 1)
                    
                    Button(role: .destructive) {
                        drawingController.clear()
                    } label: {
                        Label("Clear", systemImage: "eraser")
                            .foregroundStyle(.red)
                    }
                    .disabled(strokes == 0)
                    
                    Text("Total strokes: \(strokes ?? 0)")
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
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
}

//#Preview {
//    DrawingView()
//      .environmentObject(Storage())
//}
