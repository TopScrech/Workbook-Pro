import SwiftUI
import SwiftData

struct NoteListView: View {
    @EnvironmentObject private var store: ValueStore
    
    @Query private var notes: [Note]
        
    var body: some View {
        if store.listView {
            NoteList(notes)
        } else {
            NoteGrid(notes)
        }
    }
}
