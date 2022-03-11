import CoreGraphics

extension CGPoint {
    func delta(sum other: CGPoint) -> CGFloat {
        let result = delta(other: other)
        return abs(result.x) + abs(result.y)
    }
    
    func delta(other: Self) -> Self {
        .init(x: x - other.x, y: y - other.y)
    }
}
