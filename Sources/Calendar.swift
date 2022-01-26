import Foundation

extension Calendar {
    static var global = current

    var offset: Int32 {
        .init(timeZone.secondsFromGMT())
    }
}
