import SwiftUI

struct SettingsAppearancePicker: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        Picker("Appearance", selection: $store.appearance) {
            ForEach(ColorTheme.allCases) { theme in
                Text(theme.loc)
                    .tag(theme)
            }
        }
    }
}

#Preview {
    SettingsAppearancePicker()
        .environmentObject(ValueStore())
}
