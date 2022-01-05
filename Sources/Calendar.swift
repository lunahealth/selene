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
    
    func journal(from: Date) -> Date {
        var components = dateComponents([.year, .month, .day], from: from)
        components.timeZone = .init(secondsFromGMT: 0)
        return date(from: components) ?? from
    }
}
