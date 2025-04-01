import PencilKit

extension DrawingVC {
    func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        // Access the selected tool
        let tool = toolPicker.selectedTool
        
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
