import SwiftUI

struct NoteList: View {
    @Environment(\.modelContext) private var modelContext
    
    private let notes: [Note]
    
    init(_ notes: [Note]) {
        self.notes = notes
    }
    
    var body: some View {
        List {
            Section {
                ForEach(notes.filter { $0.isPinned }) { note in
                    NoteCard(note)
                }
//                .onDelete(perform: deleteItems)
            } header: {
                Label("Pinned", systemImage: "pin")
            }
            
            ForEach(notes.filter { !$0.isPinned }) { note in
                NoteCard(note)
            }
//            .onDelete(perform: deleteItems)
        }
    }
    
//    private func deleteItems(offsets: IndexSet) {
//        for index in offsets {
//            modelContext.delete(notes[index])
//        }
//    }
}

//#Preview {
//    NoteList()
//}
