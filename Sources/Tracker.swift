import Foundation
import CoreGraphics

public struct Tracker: Navigator {
    public let origin = CGPoint(x: 80, y: 80)
    
    public init() { }
    
    public func approach(from point: CGPoint) -> CGPoint {
        aproximate(from: point)
    }
}
