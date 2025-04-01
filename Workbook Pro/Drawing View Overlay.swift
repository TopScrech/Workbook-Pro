import SwiftUI

struct DrawingViewOverlay: View {
    @Environment(DrawingVM.self) private var vm
    
    private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Button {
                vm.previous()
            } label: {
                Image(systemName: "arrow.backward")
            }
            .disabled(vm.isFirstPage)
            
            Divider()
                .frame(height: 20)
            
            if let selectedPage = vm.vc?.selectedPage {
                Text("Page \(selectedPage + 1) of \(note.pages.count)")
                    .monospacedDigit()
            }
            
            Divider()
                .frame(height: 20)
            
            Button {
                vm.next()
            } label: {
                Image(systemName: vm.isLastPage ? "plus" : "arrow.forward")
            }
        }
        .footnote()
        .padding(.horizontal, 4)
        .foregroundStyle(.foreground)
        .background(.ultraThickMaterial, in: .rect(cornerRadius: 5))
        .padding(5)
    }
}

//#Preview {
//    DrawingViewOverlay()
//        .environment(DrawingVM())
//}
