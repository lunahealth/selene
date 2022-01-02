import XCTest
@testable import Selene

final class CalendarTests: XCTestCase {
    func testTrackingWeeek() {
        XCTAssertEqual(7, Calendar.global.week.count)
        XCTAssertTrue(Calendar.global.isDateInToday(Calendar.global.week.last!))
        XCTAssertEqual(6, Calendar.global.dateComponents([.day], from: Calendar.global.week.first!, to: .now).day!)
    }
}
