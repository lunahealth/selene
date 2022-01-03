import Foundation

public final class Observatory {
    private(set) var cache = [Date : Moon]()
    private let coords: Coords
    
    public var week: [Day] {
        Calendar
            .global
            .week
            .map {
                .init(id: $0, moon: moon(for: $0), journal: $0.journal)
            }
    }
    
    public init(coords: Coords) {
        self.coords = coords.flatten
    }
    
    public func equals(to other: Coords) -> Bool {
        coords == other.flatten
    }
    
    public func moon(for date: Date) -> Moon {
        let date = date.flatten
        guard let cached = cache[date] else {
            return add(date: date)
        }
        return cached
    }
    
    private func add(date: Date) -> Moon {
        let julianDay = date.julianDay
        let moon = Moon(julianDay: julianDay, sun: Earth.sun(julianDay: julianDay), location: coords.radians)
        cache[date] = moon
        return moon
    }
}
