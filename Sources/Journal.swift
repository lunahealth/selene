import Foundation
import Archivable

struct Journal: Storable {
    let timestamp: UInt32
    
    var data: Data {
        .init()
        .adding(timestamp)
    }
    
    init(data: inout Data) {
        timestamp = data.number()
    }
    
    init(timestamp: UInt32 = Calendar.global.today) {
        self.timestamp = timestamp
    }
}
