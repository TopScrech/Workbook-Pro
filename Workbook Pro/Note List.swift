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
                    VStack {
                        if let imageData = note.image, let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 200, height: 300)
                        }
                        
                        Text(note.name)
                    }
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

#Preview {
    NoteList()
}
