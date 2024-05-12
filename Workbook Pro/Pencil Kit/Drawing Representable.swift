import SwiftUI

struct DrawingRepresentable: UIViewControllerRepresentable {
    @Binding var drawingData: [Data]
    @Binding var imageData: Data?
    @EnvironmentObject var controller: DrawingVM
    
    //    init(_ drawingData: Binding<Data>, _ imageData: Binding<Data?>) {
    //        _drawingData = drawingData
    //        _imageData = imageData
    //    }
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        print(#function)
        
        let viewController = DrawingViewController()
        viewController.pages = $drawingData
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
            parent.imageData = data
        }
    }
}
