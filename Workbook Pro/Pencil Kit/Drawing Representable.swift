import SwiftUI

struct DrawingRepresentable: UIViewControllerRepresentable {
    @EnvironmentObject private var controller: DrawingVM
    
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        print(#function)
        
        let viewController = DrawingViewController()
        viewController.note = $note
        
        controller.vc = viewController
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        controller.vc = uiViewController
    }
}
