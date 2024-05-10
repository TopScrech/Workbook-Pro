import SwiftUI

struct DrawingView: View {
    @Bindable var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        DrawingRepresentable($note.drawing, $note.image)
            .ignoresSafeArea()
        
        //        Button("Clear") {
        //            vc.clearCanvas()
        //        }
        //
        //        Button("Undo") {
        //            vc.undo()
        //        }
        //
        //        Button("Redo") {
        //            vc.redo()
        //        }
    }
}

//#Preview {
//    DrawingView()
//}
