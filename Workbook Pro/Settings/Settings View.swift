import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        List {
            Toggle("Show nav bar", isOn: $store.showNavBar)
            
            Toggle("Show status bar", isOn: $store.showStatusBar)
            
            Section("BETA") {
                Toggle("Enable Group Activities", isOn: $store.enableGroupActivities)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ValueStore())
}
