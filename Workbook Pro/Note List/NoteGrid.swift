import SwiftUI

struct NoteGrid: View {
    private let notes: [Note]
    
    init(_ notes: [Note]) {
        self.notes = notes
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 400))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                Section {
                    ForEach(notes.filter { $0.isPinned }) { note in
                        NoteCard(note)
                    }
                }
                
                ForEach(notes.filter { !$0.isPinned }) { note in
                    NoteCard(note)
                }
            }
        }
    }
}

//#Preview {
//    NoteGrid()
//}
