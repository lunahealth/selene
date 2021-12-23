import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle
private let radius = 60.0

public struct Wheel: Equatable {
    public let radians: Double
    let point: CGPoint
    private let date: Date
    
    public init(date: Date, moon: Moon, correction: Double) {
        radians = .pi + moon.inclination * (moon.apparentAngle < 0 ? -1 : 1) + correction
        point = .init(x: cos(radians), y: sin(radians))
        self.date = date
    }
    
    public func origin(size: CGSize, padding: CGFloat) -> CGPoint {
        let width_2 = size.width / 2
        let height_2 = size.height / 2
        let side = min(width_2, height_2) - padding
        return .init(x: width_2 + side * point.x, y: height_2 + side * point.y)
    }
    
    public func move(point: CGPoint, size: CGSize, padding: CGFloat) -> Date? {
        guard accept(point: point, size: size, padding: padding) else { return nil }
        return move(point: point, size: size)
    }
    
    func accept(point: CGPoint, size: CGSize, padding: CGFloat) -> Bool {
        {
            abs($0.x - point.x) < radius && abs($0.y - point.y) < radius
        } (origin(size: size, padding: padding))
    }
    
    func move(point: CGPoint, size: CGSize) -> Date {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let originX = point.x - center.x
        let originY = center.y - point.y
        var position = atan2(originX, originY) - .pi_2
        
        if position < 0 {
            position += .pi2
        }
        
        var delta = position - radians
        
        if abs(delta) > .pi {
            delta += .pi2
        }
        
        return move(radians: delta)
    }
    
    func move(radians: Double) -> Date {
        Calendar.current.date(byAdding: .day, value: .init(round(radians / cycleRadians)), to: date) ?? date
    }
}
