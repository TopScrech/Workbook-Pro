import SwiftUI
import SwiftData

struct NoteList: View {
    @EnvironmentObject private var store: ValueStore
    
    @Query private var notes: [Note]
    
    private let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 400))
    ]
    
    var body: some View {
        if store.listView {
            List {
                ForEach(notes.filter { $0.isPinned }) { note in
                    NoteCard(note)
                }
                
                Section {
                    ForEach(notes.filter { !$0.isPinned }) { note in
                        NoteCard(note)
                    }
                    //                    .onDelete(perform: deleteItems)
                }
            }
        } else {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(notes.filter { $0.isPinned }) { note in
                        NoteCard(note)
                    }
                    
                    Section {
                        ForEach(notes.filter { !$0.isPinned }) { note in
                            NoteCard(note)
                        }
                    }
                }
            }
        }
    }
}
