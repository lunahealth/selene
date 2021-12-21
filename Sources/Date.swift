import Foundation

private let J1970 = 2440588.0
private let J2000 = 2451545.0
private let secondsInADay = 86400.0
private let flatHour = 21

extension Date {
    var julianDay: Double {
        (timeIntervalSince1970 / secondsInADay) - 0.5 + J1970 - J2000
    }
    
    var flatten: Self {
        var components = Calendar.current.dateComponents([.timeZone, .year, .month, .day], from: self)
        components.hour = flatHour
        return Calendar.current.date(from: components) ?? self
    }
}
