import SwiftUI
import PencilKit

struct AppContainer: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        NavigationStack {
            NoteList()
        }
        .statusBarHidden(!store.showStatusBar)
    }
}
