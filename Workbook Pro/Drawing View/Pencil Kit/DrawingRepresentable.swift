import SwiftUI

struct DrawingRepresentable: UIViewControllerRepresentable {
    @Environment(DrawingVM.self) private var controller
    
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    func makeUIViewController(context: Context) -> DrawingVC {
        print(#function)
        
        let viewController = DrawingVC()
        viewController.note = $note
        
        controller.vc = viewController
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: DrawingVC, context: Context) {
        controller.vc = uiViewController
    }
}
