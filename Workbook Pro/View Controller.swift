import UIKit
import SwiftUI
import PencilKit

struct DrawingViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DrawingViewController {
        DrawingViewController()
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        // Update as needed.
    }
    
    // Example methods for Clear, Undo, and Redo buttons
    func clearCanvas(on viewController: DrawingViewController) {
        viewController.clearCanvas()
    }
    
    func undo(on viewController: DrawingViewController) {
        viewController.undo()
    }
    
    func redo(on viewController: DrawingViewController) {
        viewController.redo()
    }
}

final class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIScreenshotServiceDelegate {
    private let toolPicker = PKToolPicker()
    private let canvasView = PKCanvasView()
    
    let canvasOverscrollHeight: CGFloat = 800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the canvas view
        canvasView.frame = view.bounds
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvasView.drawingPolicy = .pencilOnly
        canvasView.delegate = self
        canvasView.isScrollEnabled = true
        canvasView.alwaysBounceVertical = true
        
        view.addSubview(canvasView)
        
        // Configure the tool picker
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        canvasView.becomeFirstResponder()
    }
    
    // Tool Picker Delegate Methods
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        print(#function)
        
        updateLayout(for: toolPicker)
    }
    
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        print(#function)
        
        updateLayout(for: toolPicker)
    }
    
    private func updateLayout(for toolPicker: PKToolPicker) {
        print(#function)
        
        let obscuredFrame = toolPicker.frameObscured(in: canvasView)
        
        if obscuredFrame.isNull {
            canvasView.contentInset = .zero
        } else {
            canvasView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: canvasView.bounds.maxY - obscuredFrame.minY, right: 0)
        }
        
        canvasView.scrollIndicatorInsets = canvasView.contentInset
    }
    
    // Canvas View Delegate
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(#function)
        updateContentSizeForDrawing()
    }
    
    func updateContentSizeForDrawing() {
        // Update the content size to match the drawing
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        let contentWidth = UIScreen.main.bounds.width
        
        // Adjust the content size to always be bigger than the drawing height
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + canvasOverscrollHeight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        
        canvasView.contentSize = CGSize(width: contentWidth * canvasView.zoomScale, height: contentHeight)
    }
    
    // Screenshot Service Delegate Methods
    func screenshotService(_ screenshotService: UIScreenshotService, generateContentForScreenshotWithImage image: UIImage, completionHandler: @escaping (UIImage?) -> Void) {
        completionHandler(image)
    }
    
    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
    
    func undo() {
        undoManager?.undo()
    }
    
    func redo() {
        undoManager?.redo()
    }
}
