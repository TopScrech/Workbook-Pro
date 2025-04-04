import SwiftUI
import SwiftData

struct NoteCard: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    @State private var alertRename = false
    
    var body: some View {
        NavigationLink {
            DrawingView(note)
        } label: {
            VStack {
                NoteCardPreview(note)
                
                HStack {
                    Text(note.name)
                        .numericTransition()
                        .animation(.default, value: note.name)
                    
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .foregroundStyle(.red)
                    }
                }
                
                Text("\(note.pages.count) pages")
                    .footnote()
                    .secondary()
            }
            .padding()
            //            .overlay(alignment: .topTrailing) {
            //                Image(systemName: "xmark")
            //                    .title()
            //                    .foregroundColor(.red)
            //                    .padding(10)
            //                    .background(.ultraThinMaterial, in: .circle)
            //            }
        }
        .foregroundStyle(.foreground)
        .alert("Rename", isPresented: $alertRename) {
            TextField("Some note", text: $note.name)
        }
        .contextMenu {
            Button {
                alertRename = true
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            
            Button {
                note.isPinned.toggle()
            } label: {
                let text = note.isPinned ? "Unpin" : "Pin"
                let icon = note.isPinned ? "pin.slash" : "pin"
                
                Label(text, systemImage: icon)
            }
            
            Button {
                modelContext.insert(
                    Note(note.name, pages: note.pages, image: note.image)
                )
            } label: {
                Label("Duplicate", systemImage: "plus.square.on.square")
            }
            
            Divider()
            
            Button(role: .destructive) {
                deleteItems(note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func create() {
        modelContext.insert(
            Note("Test")
        )
    }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
    
    private func deleteItems(_ note: Note) {
        modelContext.delete(note)
    }
}

//#Preview {
//    NoteCard()
//}
