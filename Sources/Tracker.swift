import Foundation
import CoreGraphics

public struct Tracker: Navigator {
    public let origin = CGPoint(x: 50, y: 50)
    
    public init() { }
    
    public func approach(from point: CGPoint) -> CGPoint {
        let deltaX = origin.x - point.x
        let deltaY = origin.y - point.y
        return .init(x: abs(deltaX) > 1 ? point.x + (deltaX / 20) : origin.x,
                     y: abs(deltaY) > 1 ? point.y + (deltaY / 20) : origin.y)
    }
}
