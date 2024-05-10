import UIKit
import SwiftUI
import PencilKit

struct DrawingViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DrawingViewController {
        DrawingViewController()
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        // Update as needed
    }
}

final class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIScreenshotServiceDelegate {
    private let toolPicker = PKToolPicker()
    private let canvasView = PKCanvasView()
    let canvasOverscrollHeight: CGFloat = UIScreen.main.bounds.height
    
    private let drawingFilePath: URL = {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentDirectory.appendingPathComponent("drawing.data")
    }()
    
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
        
        // Load saved drawing
        loadDrawing()
        
        // Configure the tool picker
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        canvasView.becomeFirstResponder()
    }
    
    // Canvas View Delegate
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(#function)
        updateContentSizeForDrawing()
        saveDrawing() // Save drawing on each change
    }
    
    private func saveDrawing() {
        do {
            let data = canvasView.drawing.dataRepresentation()
            try data.write(to: drawingFilePath)
            print("Drawing saved to \(drawingFilePath)")
        } catch {
            print("Error saving drawing: \(error.localizedDescription)")
        }
    }
    
    private func loadDrawing() {
        do {
            let data = try Data(contentsOf: drawingFilePath)
            let drawing = try PKDrawing(data: data)
            canvasView.drawing = drawing
            print("Drawing loaded from \(drawingFilePath)")
        } catch {
            print("No saved drawing found or error loading drawing: \(error.localizedDescription)")
        }
    }
    
    
    //final class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIScreenshotServiceDelegate {
    //    private let toolPicker = PKToolPicker()
    //    private let canvasView = PKCanvasView()
    //
    //    let canvasOverscrollHeight: CGFloat = UIScreen.main.bounds.height
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Set up the canvas view
    //        canvasView.frame = view.bounds
    //        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //        canvasView.drawingPolicy = .pencilOnly
    //        canvasView.delegate = self
    //        canvasView.isScrollEnabled = true
    //        canvasView.alwaysBounceVertical = true
    //
    //        view.addSubview(canvasView)
    //
    //        // Configure the tool picker
    //        toolPicker.setVisible(true, forFirstResponder: canvasView)
    //        toolPicker.addObserver(canvasView)
    //        toolPicker.addObserver(self)
    //        canvasView.becomeFirstResponder()
    //    }
    
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
