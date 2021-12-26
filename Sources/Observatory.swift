import Foundation

public struct Observatory {
    private(set) var cache = [Input : Moon]()
    
    public init() { }
    
    public mutating func week(coords: Coords) -> [Day] {
        Calendar
            .current
            .trackingWeek
            .map {
                .init(id: $0, moon: moon(input: .init(date: $0, coords: coords)))
            }
    }
    
    public mutating func moon(input: Input) -> Moon {
        guard let cached = cache[input] else {
            return add(input: input)
        }
        return cached
    }
    
    private mutating func add(input: Input) -> Moon {
        let julianDay = input.date.julianDay
        let moon = Moon(julianDay: julianDay, sun: Earth.sun(julianDay: julianDay), location: input.coords.radians)
        cache[input] = moon
        return moon
    }
}
