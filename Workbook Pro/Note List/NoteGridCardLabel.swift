import SwiftUI

struct NoteGridCardLabel: View {
    @Bindable private var note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        VStack {
            NoteCardPreview(note)
            
            HStack {
                Text(note.name)
                    .numericTransition()
                    .animation(.default, value: note.name)
                
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundStyle(.red)
                }
            }
            
            Text("\(note.pages.count) pages")
                .footnote()
                .secondary()
        }
        .padding()
        //            .overlay(alignment: .topTrailing) {
        //                Image(systemName: "xmark")
        //                    .title()
        //                    .foregroundColor(.red)
        //                    .padding(10)
        //                    .background(.ultraThinMaterial, in: .circle)
        //            }
    }
}

//#Preview {
//    NoteGridCardLabel()
//}
