import Foundation
import CoreGraphics

public struct Tracker: Navigator {
    public let origin: CGPoint
    
    public init(size: CGSize) {
        origin = .init(x: size.width / 2, y: 85)
    }
    
    public func approach(from point: CGPoint) -> CGPoint {
        aproximate(from: point)
    }
}
