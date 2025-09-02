import ScrechKit

struct DrawingViewOverlay: View {
    @Environment(DrawingVM.self) private var vm
    
    private var pageCount: Int
    
    init(_ pageCount: Int) {
        self.pageCount = pageCount
    }
    
    var body: some View {
        HStack(spacing: 4) {
            SFButton("arrow.backward") {
                vm.previous()
            }
            .disabled(vm.isFirstPage)
            
            Divider()
                .frame(height: 20)
            
            if let selectedPage = vm.vc?.selectedPage {
                Text("Page \(selectedPage + 1) of \(pageCount)")
                    .monospacedDigit()
            }
            
            Divider()
                .frame(height: 20)
            
            SFButton(vm.isLastPage ? "plus" : "arrow.forward") {
                vm.next()
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
