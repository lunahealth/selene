import Foundation

public struct Wheel {
    public let progress: Double
    private let date: Date
    
    public init(date: Date, moon: Moon) {
        progress = .pi + moon.inclination * (moon.parallacticAngle < 0 ? -1 : 1)
        self.date = date
    }
}
