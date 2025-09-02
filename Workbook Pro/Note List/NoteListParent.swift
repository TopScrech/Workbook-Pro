import ScrechKit
import SwiftData

struct NoteListParent: View {
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NoteListView()
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
            .overlay(alignment: .bottomTrailing) {
                Button {
                    create()
                } label: {
                    Image(.add)
                        .resizable()
                        .frame(50)
                        .padding(8)
                        .background(.ultraThinMaterial, in: .circle)
                }
                .padding(.trailing)
            }
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
    }
    
    private func create() {
        modelContext.insert(
            Note("New Note")
        )
    }
}

#Preview {
    NavigationStack {
        NoteListParent()
            .modelContainer(for: Note.self)
    }
}
