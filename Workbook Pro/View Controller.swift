import SwiftUI
import PencilKit

struct DrawingRepresentable: UIViewControllerRepresentable {
    @Binding var drawingData: Data
    @Binding var imageData: Data?

    init(_ drawingData: Binding<Data>, _ imageData: Binding<Data?>) {
        _drawingData = drawingData
        _imageData = imageData
    }

    func makeUIViewController(context: Context) -> DrawingViewController {
        let viewController = DrawingViewController()
        viewController.drawingData = $drawingData
        viewController.delegate = context.coordinator // Set the delegate
        return viewController
    }

    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        // Nothing specific to update for now
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

//struct DrawingRepresentable: UIViewControllerRepresentable {
//    @Binding var drawingData: Data
//    
//    init(_ drawingData: Binding<Data>) {
//        _drawingData = drawingData
//    }
//    
//    func makeUIViewController(context: Context) -> DrawingViewController {
//        let viewController = DrawingViewController()
//        viewController.drawingData = $drawingData // Pass the binding to the ViewController
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
//        
//    }
//}

protocol DrawingViewControllerDelegate: AnyObject {
    func didCaptureImage(_ data: Data)
}

final class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {
    var drawingData: Binding<Data>?
    weak var delegate: DrawingViewControllerDelegate?
    
    private let toolPicker = PKToolPicker()
    private let canvasView = PKCanvasView()
    private let canvasOverscrollHeight: CGFloat = UIScreen.main.bounds.height * 1.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up canvas
        canvasView.frame = view.bounds
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvasView.drawingPolicy = .pencilOnly
        canvasView.delegate = self
        canvasView.isScrollEnabled = true
        canvasView.alwaysBounceVertical = true
        
        view.addSubview(canvasView)
        
        // Load saved drawing
        loadDrawing(from: drawingData?.wrappedValue ?? Data())
        
        // Configure tool picker
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        canvasView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        
        super.viewWillDisappear(animated)
        
        // Capture a screenshot of the canvas
        if let capturedImage = canvasView.asImage()?.heicData() {
            delegate?.didCaptureImage(capturedImage)
        }
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(#function)
        
        updateContentSizeForDrawing()
        saveDrawing()
    }
    
    private func saveDrawing() {
        print(#function)
        
        let data = canvasView.drawing.dataRepresentation()
        
        drawingData?.wrappedValue = data
    }
    
    func loadDrawing(from data: Data) {
        print(#function)
        
        if let drawing = try? PKDrawing(data: data) {
            canvasView.drawing = drawing
        }
    }
    
    // MARK: Tool Picker Delegate Methods
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
        // Update content size to match the drawing
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        let contentWidth = UIScreen.main.bounds.width
        
        // Adjust content size to always be bigger than drawing height
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + canvasOverscrollHeight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        
        canvasView.contentSize = CGSize(width: contentWidth * canvasView.zoomScale, height: contentHeight)
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

// Extension to render the canvas view as an image
extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

// Extension to convert UIImage to HEIC data
//extension UIImage {
//    func heicData() -> Data? {
//        let options: NSDictionary = [
//            kCGImageDestinationLossyCompressionQuality: 0.8
//        ]
//        let data = NSMutableData()
//        guard let imageDestination = CGImageDestinationCreateWithData(data, AVFileType.heic as CFString, 1, nil) else {
//            return nil
//        }
//        CGImageDestinationAddImage(imageDestination, self.cgImage!, options)
//        CGImageDestinationFinalize(imageDestination)
//        return data as Data
//    }
//}
