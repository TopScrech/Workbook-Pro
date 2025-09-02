import SwiftUI

final class ValueStore: ObservableObject {
    @AppStorage("appearance") var appearance: ColorTheme = .system
    @AppStorage("list_view") var listView = true
    
    // Beta
    @AppStorage("enable_group_activities") var enableGroupActivities = false
    
    // Debug
    @AppStorage("show_status_bar") var showStatusBar = true
    @AppStorage("show_nav_bar") var showNavBar = true
}
