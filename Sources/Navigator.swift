import Foundation
import CoreGraphics

public protocol Navigator {
    var origin: CGPoint { get }
    
    func approach(from point: CGPoint) -> CGPoint
    func move(point: CGPoint) -> Date?
}

extension Navigator {
    public func move(point: CGPoint) -> Date? {
        return nil
    }
    
    func aproximate(from point: CGPoint) -> CGPoint {
        let delta = origin.delta(other: point)
        return .init(x: abs(delta.x) > 1 ? point.x + (delta.x / 20) : origin.x,
                     y: abs(delta.y) > 1 ? point.y + (delta.y / 20) : origin.y)
    }
}
