import SwiftUI
import SwiftData

struct NoteList: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 400))
    ]
    
    @State private var sheetSettings = false
    
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
                            
                            HStack {
                                Text(note.name)
                                    .foregroundStyle(.white)
                                
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
                }
                //            .onDelete(perform: deleteItems)
            }
        }
        .onPencilDoubleTap { value in
            let pos = String(describing: value.hoverPose)
            
            print("Double tap: \(pos)")
        }
        .onPencilSqueeze { phase in
            print("Squeeze: \(phase)")
        }
        .sheet($sheetSettings) {
            SettingsView()
        }
        .overlay {
            if notes.isEmpty {
                ContentUnavailableView {
                    Text("You don't have any notes yet")
                } actions: {
                    Button {
                        create()
                    } label: {
                        Text("Create new")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    sheetSettings = true
                } label: {
                    Image(systemName: "gear")
                        .semibold()
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    create()
                } label: {
#warning("Too big image size")
                    Image(.add)
                        .resizable()
                        .frame(width: 32, height: 32)
                }
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

#Preview {
    NavigationStack {
        NoteList()
            .modelContainer(for: Note.self)
    }
}
