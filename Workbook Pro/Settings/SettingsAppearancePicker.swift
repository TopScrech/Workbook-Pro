import SwiftUI

struct SettingsAppearancePicker: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        Picker(selection: $store.appearance) {
            ForEach(ColorTheme.allCases) { theme in
                Text(theme.loc)
                    .tag(theme)
            }
        } label: {
            Label("Appearance", systemImage: "paintbrush")
        }
    }
}

#Preview {
    SettingsAppearancePicker()
        .environmentObject(ValueStore())
}
