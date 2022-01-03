import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var journal: [UInt32 : Journal]
    public internal(set) var settings: Settings

    public var data: Data {
        .init()
        .adding(UInt16(journal.count))
        .adding(journal.flatMap {
            Data()
                .adding($0.key)
                .adding($0.value)
        })
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        journal = [:]
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        journal = (0 ..< .init(data.number() as UInt16))
            .reduce(into: [:]) { result, _ in
                result[data.number()] = .init(data: &data)
            }
        settings = data.prototype()
    }
}
