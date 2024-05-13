import SwiftUI

struct DrawingRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject var controller: DrawingVM
    
    @Bindable var note: Note
    
    //    init(_ note: Binding<Data>, _ imageData: Binding<Data?>) {
    //        _drawingData = note
    //        _imageData = imageData
    //    }
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        print(#function)
        
        let viewController = DrawingViewController()
        viewController.note = $note
        viewController.delegate = context.coordinator
        
        controller.vc = viewController
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        controller.vc = uiViewController
    }
    
    // Coordinator to handle captured image data
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: DrawingViewControllerDelegate {
        var parent: DrawingRepresentable
        
        init(_ parent: DrawingRepresentable) {
            self.parent = parent
        }
        
        func didCaptureImage(_ data: Data) {
            parent.note.image = data
        }
    }
}
