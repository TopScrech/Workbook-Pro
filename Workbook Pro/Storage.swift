import SwiftUI

final class ValueStorage: ObservableObject {
    @AppStorage("show_status_bar") var showStatusBar = true
    @AppStorage("show_nav_bar") var showNavBar = true
    @AppStorage("enable_group_activities") var enableGroupActivities = false
}
