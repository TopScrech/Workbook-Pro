import SwiftUI
import PencilKit

protocol DrawingViewControllerDelegate: AnyObject {
    func didCaptureImage(_ data: Data)
}

final class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {
    var note: Bindable<Note>?
    
    let toolPicker = PKToolPicker()
    let canvasView = PKCanvasView()
    weak var delegate: DrawingViewControllerDelegate?
    var selectedPage = 0
    
    private let canvasOverscrollHeight = UIScreen.main.bounds.height * 1.2
    
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
        loadDrawing(from: note?.pages.first?.wrappedValue ?? Data())
        
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
        if let capturedImage = canvasView.drawing.image(from: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), scale: 1).heicData() {
            delegate?.didCaptureImage(capturedImage)
        }
    }
    
    func deletePage() {
        guard let pages = note?.pages.wrappedValue else {
            return
        }
        
        // Ensure there's at least one page to delete and the selected page is within range
        guard pages.count > 0, selectedPage < pages.count else {
            return
        }
        
        // Remove page at selected index
        note?.pages.wrappedValue.remove(at: selectedPage)
        
        // After deletion, check and adjust the selectedPage if it's now out of bounds
        if selectedPage >= note!.pages.count {
            selectedPage = max(note!.pages.count - 1, 0) // Adjust to last page or to 0 if all were deleted
        }
        
        print("Count \(note!.pages.count), selected \(selectedPage)")
        loadDrawing(from: note!.pages[selectedPage].wrappedValue)
    }
    
    func addPage() {
        print(#function)
        
        note?.pages.wrappedValue.append(Data())
    }
    
    func nextPage() {
        print(#function)
        
        if note!.pages.count - 1 == selectedPage {
            addPage()
        }
        
        selectedPage += 1
        loadDrawing(from: note!.pages[selectedPage].wrappedValue)
    }
    
    func previousPage() {
        print(#function)
        
        selectedPage -= 1
        loadDrawing(from: note!.pages[selectedPage].wrappedValue)
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(#function)
        
        updateContentSizeForDrawing()
        saveDrawing()
    }
    
    private func saveDrawing() {
        print(#function)
        let data = canvasView.drawing.dataRepresentation()
        
        note?.pages[selectedPage].wrappedValue = data
    }
    
    func clear() {
        canvasView.drawing = PKDrawing()
    }
    
    func loadDrawing(from data: Data) {
        print(#function)
        
        clear()
        
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
        let contentWidth: CGFloat
        
        // Adjust content size to always be bigger than drawing height
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + canvasOverscrollHeight) * canvasView.zoomScale)
            contentWidth = max(canvasView.bounds.width, (UIScreen.main.bounds.width * canvasView.zoomScale))
        } else {
            contentHeight = canvasView.bounds.height
            contentWidth = UIScreen.main.bounds.width
        }
        
        canvasView.contentSize = CGSize(width: contentWidth * canvasView.zoomScale, height: contentHeight)
    }
}

extension DrawingViewController {
    func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        // Access the selected tool
        let tool = toolPicker.selectedTool
        
        // Print or use tool details
        printToolDetails(tool)
    }
    
    private func printToolDetails(_ tool: PKTool) {
        // Format a string with tool details and print it
        let toolDescription = description(for: tool)
        print(toolDescription)
    }
    
    private func description(for tool: PKTool) -> String {
        switch tool {
        case let inkingTool as PKInkingTool:
            "Inking Tool: Type \(inkingTool.inkType.rawValue), Color: \(inkingTool.color.hexString()), Width: \(inkingTool.width)"
            
        case let eraserTool as PKEraserTool:
            "Eraser: Type \(eraserTool.eraserType), width: \(eraserTool.width)"
            
        case let lassoTool as PKLassoTool:
            "Lasso: \(lassoTool)"
            
        default:
            "Unknown Tool"
        }
    }
}

// Helper extension to convert UIColor to Hex String for better readability
extension UIColor {
    func hexString() -> String {
        let components = self.cgColor.components ?? [0, 0, 0]
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
