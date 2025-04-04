import SwiftUI
import SwiftData

struct NoteList: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 400))
    ]
    
    //@AppStorage("view_mode") private var viewMode = false
    
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
        .sheet($sheetSettings) {
            SettingsView()
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
