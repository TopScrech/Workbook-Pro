import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var drawingVC = DrawingViewController()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Button("Clear") {
                    DrawingViewControllerRepresentable().clearCanvas(on: drawingVC)
                }
                
                Button("Undo") {
                    DrawingViewControllerRepresentable().undo(on: drawingVC)
                }
                
                Button("Redo") {
                    DrawingViewControllerRepresentable().redo(on: drawingVC)
                }
                
                DrawingViewControllerRepresentable()
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
