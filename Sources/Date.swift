import Foundation

private let J1970 = Double(2440588)
private let J2000 = Double(2451545)
private let secondsInADay = Double(86400)

extension Date {
    var julianDay: Double {
        (timeIntervalSince1970 / secondsInADay) - 0.5 + J1970 - J2000
    }
}
