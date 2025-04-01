import SwiftUI

extension DrawingVC {
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
}
