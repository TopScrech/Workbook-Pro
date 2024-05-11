import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var storage: Storage
    
    var body: some View {
        List {
            Toggle("Show nav bar", isOn: storage.$showNavBar)
            
            Toggle("Show status bar", isOn: storage.$showStatusBar)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Storage())
}
