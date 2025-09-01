import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        List {
            SettingsAppearancePicker()
            
            Toggle(isOn: $store.listView) {
                Label("List view", systemImage: "list.bullet")
            }
            
            Section("Debug") {
                Toggle(isOn: $store.enableGroupActivities) {
                    Label("SharePlay", systemImage: "shareplay")
                }
                
                Toggle("Navigation bar", isOn: $store.showNavBar)
                
                Toggle("Status bar", isOn: $store.showStatusBar)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(ValueStore())
}
