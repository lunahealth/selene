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
        let deltaX = origin.x - point.x
        let deltaY = origin.y - point.y
        return .init(x: abs(deltaX) > 1 ? point.x + (deltaX / 20) : origin.x,
                     y: abs(deltaY) > 1 ? point.y + (deltaY / 20) : origin.y)
    }
}
