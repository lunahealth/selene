import Foundation

public enum Analysing: UInt8 {
    case
    all,
    month,
    fortnight
    
    var date: Date {
        switch self {
        case .all:
            return .distantPast
        case .month:
            return Calendar.global.date(byAdding: .month, value: -1, to: .now)!
        case .fortnight:
            return Calendar.global.date(byAdding: .day, value: -14, to: .now)!
        }
    }
}
