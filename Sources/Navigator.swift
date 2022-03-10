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
}
