import ScrechKit
import SwiftData

struct NoteList: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 400))
    ]
    
    @State private var sheetSettings = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                //List {
                ForEach(notes.filter { $0.isPinned }) { note in
                    NoteCard(note)
                }
                
                ForEach(notes.filter { !$0.isPinned }) { note in
                    NoteCard(note)
                }
                //.onDelete(perform: deleteItems)
            }
        }
        .animation(.default, value: notes)
        .onPencilDoubleTap { value in
            let pos = String(describing: value.hoverPose)
            
            print("Double tap:", pos)
        }
        .onPencilSqueeze { phase in
            print("Squeeze:", phase)
        }
        .overlay {
            if notes.isEmpty {
                ContentUnavailableView {
                    Text("You don't have any notes yet")
                } actions: {
                    Button("Create new") {
                        create()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    create()
                } label: {
#warning("Too big image size")
                    Image(.add)
                        .resizable()
                        .frame(32)
                }
            }
        }
    }
    
    private func create() {
        modelContext.insert(
            Note("New Note")
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
