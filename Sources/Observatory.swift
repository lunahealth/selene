import Foundation

public struct Observatory {
    func moon(at: Date, on: Coords) async -> Moon {
        let julianDay = at.julianDay
        return .init(julianDay: julianDay, sun: .init(julianDay: julianDay))
    }
}
