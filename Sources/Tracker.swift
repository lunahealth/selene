import Foundation
import CoreGraphics

public struct Tracker: Navigator {
    public let origin = CGPoint(x: 50, y: 50)
    
    public init() { }
    
    public func approach(from point: CGPoint) -> CGPoint {
        aproximate(from: point)
    }
}
