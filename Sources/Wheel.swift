import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle
private let radius = 60.0

public struct Wheel: Equatable {
    public let radians: Double
    public let size: CGSize
    public let origin: CGPoint
    let point: CGPoint
    private let date: Date
    private let padding: CGFloat
    private let center: CGPoint
    
    public init(date: Date, moon: Moon, correction: Double, size: CGSize, padding: CGFloat) {
        radians = .pi + moon.inclination * (moon.apparentAngle < 0 ? -1 : 1) + correction
        point = .init(x: cos(radians), y: sin(radians))
        
        let width_2 = size.width / 2
        let height_2 = size.height / 2
        let side = min(width_2, height_2) - padding
        center = .init(x: width_2, y: height_2)
        origin = .init(x: width_2 + side * point.x, y: height_2 + side * point.y)
        
        self.date = date
        self.size = size
        self.padding = padding
    }
    
    public func move(point: CGPoint) -> Date? {
        guard accept(point: point) else { return nil }
        return date(for: point)
    }
    
    func accept(point: CGPoint) -> Bool {
        abs(origin.x - point.x) < radius && abs(origin.y - point.y) < radius
    }
    
    func date(for point: CGPoint) -> Date {
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
