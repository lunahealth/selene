import CoreGraphics

extension CGPoint {
    public func origin(size: CGSize, padding: CGFloat) -> CGPoint {
        let width_2 = size.width / 2
        let height_2 = size.height / 2
        let side = min(width_2, height_2) - padding
        return .init(x: width_2 + side * x, y: height_2 + side * y)
    }
}
