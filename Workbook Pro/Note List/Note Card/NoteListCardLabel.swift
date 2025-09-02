import SwiftUI

struct NoteListCardLabel: View {
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(note.name)
                    .numericTransition()
                    .animation(.default, value: note.name)
                
                Text("\(note.pages.count) pages")
                    .footnote()
                    .secondary()
            }
            
            Spacer()
            
            if note.isPinned {
                Image(systemName: "pin.fill")
                    .foregroundStyle(.red)
            }
        }
    }
}

//#Preview {
//    NoteListCardLabel()
//}
