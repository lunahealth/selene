import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle
private let radius = 60.0

public struct Tracker: Navigator {
    public let origin = CGPoint(x: 50, y: 50)
    
    public init() { }
    
    public func approach(from point: CGPoint) -> CGPoint {
        let deltaX = origin.x - point.x
        let deltaY = origin.y - point.y
        return .init(x: abs(deltaX) > 2 ? deltaX / 10 : origin.x,
                     y: abs(deltaY) > 2 ? deltaY / 10 : origin.y)
    }
}
