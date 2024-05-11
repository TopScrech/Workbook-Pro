import ScrechKit
import SwiftData

@main
struct WorkbookPro: App {
    @StateObject private var storage = Storage()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storage)
        }
        .modelContainer(sharedModelContainer)
    }
}
