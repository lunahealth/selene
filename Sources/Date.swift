import Foundation

private let J1970 = 2440588.0
private let J2000 = 2451545.0
private let secondsInADay = 86400.0

extension Date {
    var julianDay: Double {
        (timeIntervalSince1970 / secondsInADay) - 0.5 + J1970 - J2000
    }
}
