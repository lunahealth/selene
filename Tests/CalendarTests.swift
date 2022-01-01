import XCTest
@testable import Selene

final class CalendarTests: XCTestCase {
    func testTrackingWeeek() {
        XCTAssertEqual(7, Calendar.global.trackingWeek.count)
        XCTAssertTrue(Calendar.global.isDateInToday(Calendar.global.trackingWeek.last!))
        XCTAssertEqual(6, Calendar.global.dateComponents([.day], from: Calendar.global.trackingWeek.first!, to: .now).day!)
    }
}
