import ScrechKit
import SwiftData

struct NoteListParent: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NoteList()
            .animation(.default, value: notes)
            .pencilDoubleTapLogging()
            .pencilSqueezeLogging()
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
        NoteListParent()
            .modelContainer(for: Note.self)
    }
}
