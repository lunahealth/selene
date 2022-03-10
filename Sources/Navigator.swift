import Foundation
import CoreGraphics

private let cycle = 29.53
private let cycleRadians = .pi2 / cycle
private let radius = 60.0

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
