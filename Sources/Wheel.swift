import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle
private let radius = 60.0

public struct Wheel: Equatable {
    public let radians: Double
    public let origin: CGPoint
    private let date: Date
    private let side: Double
    private let center: CGPoint
    
    public init(date: Date, moon: Moon, correction: Double, size: CGSize, padding: Double) {
        radians = .pi + moon.inclination * (moon.apparentAngle < 0 ? -1 : 1) + correction
        
        let width_2 = size.width / 2
        let height_2 = size.height / 2
        side = min(width_2, height_2) - padding
        center = .init(x: width_2, y: height_2)
        origin = Self.point(for: radians, center: center, side: side)
        
        self.date = date
    }
    
    public func move(point: CGPoint) -> Date? {
        guard accept(point: point) else { return nil }
        let date = date(for: point)
        guard !Calendar.current.isDate(self.date, inSameDayAs: date) else { return nil }
        return date
    }
    
    public func approach(from point: CGPoint) -> CGPoint {
        let delta = delta(for: point)
        
        if abs(delta) > 0.005 {
            return Self.point(for: radians + delta / -30, center: center, side: side)
        }
        
        return origin
    }
    
    func accept(point: CGPoint) -> Bool {
        abs(origin.x - point.x) < radius && abs(origin.y - point.y) < radius
    }
    
    func date(for point: CGPoint) -> Date {
        move(radians: delta(for: point))
    }
    
    func move(radians: Double) -> Date {
        Calendar.current.date(byAdding: .day, value: .init(round(radians / cycleRadians)), to: date) ?? date
    }
    
    private func delta(for point: CGPoint) -> Double {
        var delta = radians(for: point) - radians
        if abs(delta) > .pi {
            delta += .pi2
        }
        return delta
    }
    
    private static func point(for radians: Double, center: CGPoint, side: Double) -> CGPoint {
        let point = CGPoint(x: cos(radians), y: sin(radians))
        return .init(x: center.x + side * point.x, y: center.y + side * point.y)
    }
    
    private func radians(for point: CGPoint) -> Double {
        let originX = point.x - center.x
        let originY = center.y - point.y
        var position = atan2(originX, originY) - .pi_2
        
        if position < 0 {
            position += .pi2
        }
        
        return position
    }
}
