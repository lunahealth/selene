import Foundation
import Archivable

struct Journal: Storable, Hashable {
    let gmt: UInt32
    
    var data: Data {
        .init()
        .adding(gmt)
    }
    
    init(data: inout Data) {
        gmt = data.number()
    }
    
    init(gmt: UInt32) {
        self.gmt = gmt
    }
    
    func hash(into: inout Hasher) {
        into.combine(gmt)
    }
}
