import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle

public struct Wheel {
    public let radians: Double
    public let point: CGPoint
    private let date: Date
    
    public init(date: Date, moon: Moon, correction: Double) {
        radians = .pi + moon.inclination * (moon.apparentAngle < 0 ? -1 : 1) + correction
        point = .init(x: cos(radians), y: sin(radians))
        self.date = date
    }
    
    public func move(radians: Double) -> Date {
        Calendar.current.date(byAdding: .day, value: .init(round(radians / cycleRadians)), to: date) ?? .now
    }
}
