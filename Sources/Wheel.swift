import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle
private let radius = 60.0

public struct Wheel: Navigator {
    public private(set) var origin = CGPoint.zero
    let radians: Double
    let side: Double
    private let date: Date
    private let center: CGPoint
    
    public init(date: Date,
                moon: Moon,
                correction: Double,
                size: CGSize,
                padding: Double,
                maxWidth: CGFloat) {
        
        radians = .pi + moon.inclination * (moon.apparentAngle < 0 ? -1 : 1) + correction
        
        let width_2 = size.width / 2
        let height_2 = size.height / 2
        side = min(min(width_2, height_2), maxWidth / 2) - padding
        center = .init(x: width_2, y: height_2)
        self.date = date
        origin = pointer(for: radians)
    }
    
    public func move(point: CGPoint) -> Date? {
        guard accept(point: point) else { return nil }
        let date = date(for: point)
        guard !Calendar.global.isDate(self.date, inSameDayAs: date) else { return nil }
        return date
    }
    
    public func approach(from point: CGPoint) -> CGPoint {
        let new = radians(for: point)
        if pointer(for: new).delta(sum: point) < 10 {
            let delta = delta(for: new)
            
            if abs(delta) > 0.005 {
                return pointer(for: new + delta / (abs(delta) > .pi
                                                      ? -2
                                                      : abs(delta) > .pi_2
                                                        ? -6
                                                        : -30))
            }
            
            return origin
        } else {
            return aproximate(from: point)
        }
    }
    
    func accept(point: CGPoint) -> Bool {
        abs(origin.x - point.x) < radius && abs(origin.y - point.y) < radius
    }
    
    func date(for point: CGPoint) -> Date {
        move(radians: delta(for: radians(for: point)))
    }
    
    func move(radians: Double) -> Date {
        Calendar.global.date(byAdding: .day, value: .init(round(radians / cycleRadians)), to: date) ?? date
    }
    
    func radians(for point: CGPoint) -> Double {
        let originX = point.x - center.x
        let originY = center.y - point.y
        var position = atan2(originX, originY) - .pi_2
        
        if position < 0 {
            position += .pi2
        }
        
        return position
    }
    
    func pointer(for radians: Double) -> CGPoint {
        let point = CGPoint(x: cos(radians), y: sin(radians))
        return .init(x: center.x + side * point.x, y: center.y + side * point.y)
    }
    
    private func delta(for rads: Double) -> Double {
        var delta = rads - radians
        if abs(delta) > .pi {
            delta += .pi2
        }
        return delta
    }
}
