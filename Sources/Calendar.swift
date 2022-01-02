import Foundation

extension Calendar {
    static var global = current

    private var offset: TimeInterval {
        .init(timeZone.secondsFromGMT())
    }
    
    var week: [Date] {
        (0 ..< 7)
            .map {
                date(byAdding: .day, value: -$0, to: .now)!
            }
            .reversed()
    }
    
    func gmtDay(from date: Date) -> Date {
        .init(timeIntervalSince1970: date.timeIntervalSince1970 + offset)
    }
}
