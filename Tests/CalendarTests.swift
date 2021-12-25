import XCTest
@testable import Selene

final class CalendarTests: XCTestCase {
    func testTrackingWeeek() {
        XCTAssertEqual(7, Calendar.current.trackingWeek.count)
        XCTAssertTrue(Calendar.current.isDateInToday(Calendar.current.trackingWeek.last!))
        XCTAssertEqual(6, Calendar.current.dateComponents([.day], from: Calendar.current.trackingWeek.first!, to: .now).day!)
    }
}
