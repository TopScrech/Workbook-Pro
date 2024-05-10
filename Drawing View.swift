import SwiftUI

struct DrawingView: View {
    @Bindable var note: Item
    
    init(_ note: Item) {
        self.note = note
    }
    
    var body: some View {
        DrawingRepresentable($note.drawing)
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
