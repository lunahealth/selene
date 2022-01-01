import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    
    public var week: [Journal] {
        []
    }
    
    var journal: [Journal]

    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: journal)
    }
    
    public init() {
        timestamp = 0
        journal = []
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        journal = data.collection(size: UInt16.self)
    }
}
