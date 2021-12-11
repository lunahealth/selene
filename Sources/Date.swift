import Foundation

extension Date {
    private static let J1970 = Double(2440588)
    private static let J2000 = Double(2451545)
    private static let secondsInADay = Double(86400)
    
    var julianDay: Double {
        (timeIntervalSince1970 / Self.secondsInADay) - 0.5 + Self.J1970 - Self.J2000
    }
}
