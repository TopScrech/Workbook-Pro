import SwiftUI
import SwiftData

struct NoteList: View {
    @Query private var notes: [Item]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NavigationLink {
                    DrawingView(note)
                } label: {
                    Text(note.name)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            Button("Create new") {
                modelContext.insert(
                    Item("Test")
                )
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
}

struct DrawingView: View {
    @Bindable var note: Item
    
    init(_ note: Item) {
        self.note = note
    }
    
    var body: some View {
        DrawingViewControllerRepresentable(drawingData: $note.drawing)
            .ignoresSafeArea()
        
        //                Button("Clear") {
        //                    vc.clearCanvas()
        //                }
        //
        //                Button("Undo") {
        //                    vc.undo()
        //                }
        //
        //                Button("Redo") {
        //                    vc.redo()
        //                }
    }
}

#Preview {
    NoteList()
}
