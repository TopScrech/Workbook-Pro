import SwiftUI
import SwiftData

struct NoteListView: View {
    @EnvironmentObject private var store: ValueStore
    
    private let notes: [Note]
    
    init(_ notes: [Note]) {
        self.notes = notes
    }
    
    var body: some View {
        if store.listView {
            NoteList(notes)
        } else {
            NoteGrid(notes)
        }
    }
}
