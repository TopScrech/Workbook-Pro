import SwiftUI

struct DrawingView: View {
    @StateObject private var drawingController = DrawingVM()
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
        
        DrawingRepresentable(drawingData: $note.pages, imageData: $note.image)
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
                    .disabled(drawingController.vc?.selectedPage == 0)
                    
                    Button("Next") {
                        drawingController.next()
                    }
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
