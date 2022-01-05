import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var journal: [UInt32 : Journal]
    public internal(set) var settings: Settings
    public internal(set) var coords: Coords

    public var data: Data {
        .init()
        .adding(coords)
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
        coords = .init(latitude: 52.522399, longitude: 13.413027)
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        coords = .init(data: &data)
        journal = (0 ..< .init(data.number() as UInt16))
            .reduce(into: [:]) { result, _ in
                result[data.number()] = .init(data: &data)
            }
        settings = .init(data: &data)
    }
}
