import PencilKit

extension DrawingViewController {
    func changeToolWidth(to newWidth: CGFloat) {
        let currentTool = toolPicker.selectedTool
        
        if let inkingTool = currentTool as? PKInkingTool {
            let modifiedInkingTool = PKInkingTool(inkingTool.inkType, color: inkingTool.color, width: newWidth)
            canvasView.tool = modifiedInkingTool
            
        } else if let eraserTool = currentTool as? PKEraserTool {
            let modifiedEraserTool = PKEraserTool(eraserTool.eraserType, width: newWidth)
            canvasView.tool = modifiedEraserTool
            
        } else {
            print("Selected Tool doesn't allow to change width")
        }
    }
}
