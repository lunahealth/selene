import Foundation
import Archivable

struct Datestamp: Storable, Hashable {
    let timestamp: UInt32
    let offset: Int32
    
    var data: Data {
        .init()
        .adding(timestamp)
        .adding(offset)
    }
    
    init(data: inout Data) {
        timestamp = data.number()
        offset = data.number()
    }
    
    init(date: Date) {
        timestamp = date.timestamp
        offset = Calendar.global.offset
    }
    
    var date: Date {
        .init(timeIntervalSince1970: .init(timestamp) - .init(Calendar.global.offset - offset))
    }
}
