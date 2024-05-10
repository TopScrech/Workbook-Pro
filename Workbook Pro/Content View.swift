import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var vc = DrawingViewController()
    
    var body: some View {
        NavigationStack {
            NoteList()
            
//            VStack(spacing: 10) {
//                //                Button("Clear") {
//                //                    vc.clearCanvas()
//                //                }
//                //                
//                //                Button("Undo") {
//                //                    vc.undo()
//                //                }
//                //
//                //                Button("Redo") {
//                //                    vc.redo()
//                //                }
//                
//                DrawingViewControllerRepresentable()
//            }
//            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
