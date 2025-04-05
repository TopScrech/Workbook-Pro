import SwiftUI

struct NoteCardPreview: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let note: Note
    
    init(_ note: Note) {
        self.note = note
    }
    
    var body: some View {
        if let imgData = note.image, let image = UIImage(data: imgData) {
            Image(uiImage: image)
                .resizable()
                .frame(width: 200, height: 300)
                .border(.white)
                .overlay {
                    if colorScheme == .light {
                        Color.black
                            .clipShape(.rect(cornerRadius: 16))
                    }
                }
        }
    }
}

//#Preview {
//    NoteCardPreview()
//}
