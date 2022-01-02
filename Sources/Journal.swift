import Foundation
import Archivable

struct Journal: Storable, Hashable {
    let gmt: UInt32
    let entries: Set<Entry>
    
    var data: Data {
        .init()
        .adding(gmt)
        .adding(size: UInt8.self, collection: entries)
    }
    
    init(data: inout Data) {
        gmt = data.number()
        entries = .init(data.collection(size: UInt8.self))
    }
    
    init(gmt: UInt32) {
        self.init(gmt: gmt, entries: [])
    }
    
    private init(gmt: UInt32, entries: Set<Entry>) {
        self.gmt = gmt
        self.entries = entries
    }
    
    func with(entry: Entry) -> Self {
        var entries = entries
        entries.remove(entry)
        entries.insert(entry)
        return .init(gmt: gmt, entries: entries)
    }
    
    func hash(into: inout Hasher) {
        into.combine(gmt)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.gmt == rhs.gmt
    }
}
