import Foundation

public final class Observatory {
    private(set) var cache = [Date : Moon]()
    private var coords = Coords(latitude: 0, longitude: 0)

    public init() { }
    
    public func update(to other: Coords) {
        let new = other.flatten
        
        guard new != coords else { return }
        
        coords = new
        cache = [:]
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
