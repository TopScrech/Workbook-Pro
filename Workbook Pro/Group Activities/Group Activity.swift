// The activity that users use to draw together

import Foundation
import GroupActivities

struct WorkbookProGroupSession: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        
        metadata.title = NSLocalizedString("Workbook Pro", comment: "Title of group activity")
        metadata.type = .generic
        
        return metadata
    }
}
