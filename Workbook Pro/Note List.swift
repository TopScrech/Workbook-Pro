import SwiftUI
import SwiftData

struct NoteList: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 400))
    ]
    
    //    @AppStorage("view_mode") private var viewMode = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                //        List {
                ForEach(notes) { note in
                    NavigationLink {
                        DrawingView(note)
                    } label: {
                        VStack {
                            if let imageData = note.image, let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 200, height: 300)
                                    .border(.white)
                            }
                            
                            Text(note.name)
                                .foregroundStyle(.white)
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
                            Button {
                                note.isPinned.toggle()
                            } label: {
                                Text(note.isPinned ? "Unpin" : "Pin")
                            }
                            
                            Button {
                                modelContext.insert(
                                    Note(note.name, drawing: note.drawing, image: note.image)
                                )
                            } label: {
                                Text("Duplicate")
                            }
                            
                            Button(role: .destructive) {
                                deleteItems(note)
                            } label: {
                                Text("Delete")
                            }
                        }
                    }
                }
                //            .onDelete(perform: deleteItems)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Create new") {
                    modelContext.insert(
                        Note("Test")
                    )
                }
            }
        }
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

#Preview {
    NavigationStack {
        NoteList()
            .modelContainer(for: Note.self)
    }
}
