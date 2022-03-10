import Foundation
import CoreGraphics

public struct Tracker: Navigator {
    public let origin = CGPoint(x: 65, y: 65)
    
    public init() { }
    
    public func approach(from point: CGPoint) -> CGPoint {
        aproximate(from: point)
    }
}
