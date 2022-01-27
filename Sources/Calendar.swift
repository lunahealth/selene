import Foundation

extension Calendar {
    var offset: Int32 {
        .init(timeZone.secondsFromGMT())
    }
}
