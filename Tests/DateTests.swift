import XCTest
@testable import Selene

final class DateTests: XCTestCase {
    func testJulianDay() {
        XCTAssertEqual(-0.5, Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0), year: 2000))?.julianDay)
    }
}
