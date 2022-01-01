import Foundation

private let J1970 = 2440588.0
private let J2000 = 2451545.0
private let secondsInADay = 86400.0
private let flatHour = 21

extension Date {
    public var today: Bool {
        Calendar.global.isDateInToday(self)
    }
    
    public var trackable: Bool {
        self <= .now
        ? {
            $0 > -7 && $0 < 1
        } (Calendar.global.dateComponents([.day], from: .now, to: self).day!)
        : false
    }
    
    var julianDay: Double {
        (timeIntervalSince1970 / secondsInADay) - 0.5 + J1970 - J2000
    }
    
    var flatten: Self {
        var components = Calendar.global.dateComponents([.timeZone, .year, .month, .day], from: self)
        components.hour = flatHour
        return Calendar.global.date(from: components) ?? self
    }
}
