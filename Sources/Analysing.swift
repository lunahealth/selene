import Foundation

public enum Analysing: UInt8 {
    case
    all,
    month
    
    var date: Date {
        switch self {
        case .all:
            return .distantPast
        case .month:
            return Calendar.global.date(byAdding: .month, value: -1, to: .now)!
        }
    }
}
