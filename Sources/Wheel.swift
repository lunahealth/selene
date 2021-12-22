import Foundation

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle

public struct Wheel {
    public let progress: Double
    private let date: Date
    
    public init(date: Date, moon: Moon) {
        progress = .pi + moon.inclination * (moon.apparentAngle < 0 ? -1 : 1)
        self.date = date
    }
    
    public func move(radians: Double) -> Date {
        Calendar.current.date(byAdding: .day, value: .init(round(radians / cycleRadians)), to: date) ?? .now
    }
}
