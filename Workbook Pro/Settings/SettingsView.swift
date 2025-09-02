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
                
                Toggle(isOn: $store.showStatusBar) {
                    Label("Status bar", systemImage: "menubar.arrow.up.rectangle")
                }
                
                Toggle("Navigation bar", isOn: $store.showNavBar)
            }
        }
        .navigationTitle("Settings")
        .frame(maxWidth: 500)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(ValueStore())
}
