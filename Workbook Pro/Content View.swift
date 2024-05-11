import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var vc = DrawingViewController()
    
    var body: some View {
        NavigationStack {
            NoteList()
        }
    }
}
