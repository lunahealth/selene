import Foundation
import Dater
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var settings: Settings
    public internal(set) var coords: Coords
    private(set) var journal: Set<Journal>

    public var calendar: [Days<Journal>] {
        let journal = journal.reduce(into: [:]) {
            $0[$1.date] = $1
        }
        
        return Array(journal.keys.sorted())
            .calendar { date in
                self[date] ?? .init(date: date)
            }
    }
    
    public var data: Data {
        .init()
        .adding(coords)
        .adding(size: UInt16.self, collection: journal)
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        journal = []
        settings = .init()
        coords = .init(latitude: 52.522399, longitude: 13.413027)
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        self.timestamp = timestamp
        var data = data
        coords = .init(data: &data)
        journal = .init(data.collection(size: UInt16.self))
        settings = .init(data: &data)
    }
    
    public subscript(_ date: Date) -> Journal? {
        journal
            .first {
                Calendar.global.isDate($0.date, inSameDayAs: date)
            }
    }
    
    mutating func replace(item: Journal) {
        remove(date: item.date)
        journal.insert(item)
    }
    
    mutating func remove(date: Date) {
        _ = journal
            .firstIndex {
                Calendar.global.isDate($0.date, inSameDayAs: date)
            }
            .map {
                journal.remove(at: $0)
            }
    }
    
    mutating func clear() {
        journal = []
    }
    
    mutating func remove(trait: Trait) {
        journal = journal
            .reduce(into: []) {
                let journal = $1.removing(trait: trait)
                guard !journal.traits.isEmpty else { return }
                $0.insert(journal)
            }
    }
}
