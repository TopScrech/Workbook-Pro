import SwiftUI
import PencilKit

struct AppContainer: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        NavigationStack {
            NoteListParent()
        }
        .statusBarHidden(!store.showStatusBar)
#if !os(visionOS)
        .preferredColorScheme(store.appearance.scheme)
#endif
    }
}
