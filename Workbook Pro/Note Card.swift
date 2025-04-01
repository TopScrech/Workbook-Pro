import SwiftUI
import SwiftData

struct NoteCard: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    private let note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        NavigationLink {
            DrawingView(note)
        } label: {
            VStack {
                if let imageData = note.image, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 200, height: 300)
                        .border(.white)
                        .overlay {
                            if colorScheme == .light {
                                Color.black
                                    .clipShape(.rect(cornerRadius: 16))
                            }
                        }
                }
                
                HStack {
                    Text(note.name)
                    
                    if note.isPinned {
                        Image(systemName: "pin")
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding()
            //                        .overlay(alignment: .topTrailing) {
            //                            Image(systemName: "xmark")
            //                                .title()
            //                                .foregroundColor(.red)
            //                                .padding(10)
            //                                .background(.ultraThinMaterial, in: .circle)
            //                        }
            .contextMenu {
                Text(note.pages.description)
                
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
        .foregroundStyle(.foreground)
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
