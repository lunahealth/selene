import Foundation

extension Calendar {
    static var global = current

    private var offset: TimeInterval {
        .init(timeZone.secondsFromGMT())
    }
    
    func journal(from: Date) -> Date {
        var components = dateComponents([.year, .month, .day], from: from)
        components.timeZone = .init(secondsFromGMT: 0)
        return date(from: components) ?? from
    }
}
