import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        List {
            SettingsAppearancePicker()
            
            Section("BETA") {
                Toggle("Group Activities", isOn: $store.enableGroupActivities)
            }
            
            Section("Debug") {
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
