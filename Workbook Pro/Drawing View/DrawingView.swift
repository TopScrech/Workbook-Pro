import SwiftUI

struct DrawingView: View {
    @Bindable private var vm = DrawingVM()
    @EnvironmentObject private var store: ValueStore
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        DrawingRepresentable(note)
            .navigationTitle(note.name)
            .ignoresSafeArea()
            .toolbar(store.showNavBar ? .visible : .hidden, for: .navigationBar)
            .drawingToolbar(vm: vm, note: note)
            .overlay(alignment: .topLeading) {
                DrawingViewOverlay(note)
            }
            .environment(vm)
            .task {
                for await session in WorkbookProGroupSession.sessions() {
                    vm.vc?.configureGroupSession(session)
                }
            }
            .gesture(
                store.showNavBar ? nil : DragGesture()
                    .onChanged { value in
                        let edgeWidth = 20.0
                        let minimumDragTranslation = 50.0
                        
                        if value.startLocation.x < edgeWidth && value.translation.width > minimumDragTranslation {
                            print("Dismissed with a gesture")
                            dismiss()
                        }
                    }
            )
    }
}

#Preview {
    DrawingView(.init("Preview"))
        .environmentObject(ValueStore())
}
