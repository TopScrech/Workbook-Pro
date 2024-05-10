import SwiftUI
import SwiftData

struct NoteList: View {
    @Query private var notes: [Item]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List(notes) { note in
            NavigationLink {
                DrawingView(note: note)
            } label: {
                Text(note.name)
            }
        }
        .toolbar {
            Button("Create new") {
                modelContext.insert(Item("Test"))
            }
        }
    }
    
    func save() {
        
    }
}

struct DrawingView: View {
    @Bindable var note: Item

//    init(note: Item) {
//        _drawingData = State(initialValue: note.drawing)
//    }

    var body: some View {
        DrawingViewControllerRepresentable()
    }
}

#Preview {
    NoteList()
}
