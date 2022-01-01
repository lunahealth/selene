import XCTest
@testable import Selene

final class DateTests: XCTestCase {
    func testJulianDay() {
        XCTAssertEqual(-0.5, Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0), year: 2000))?.julianDay)
    }
    
    func testTrackable() {
        XCTAssertTrue(Date.now.trackable)
        XCTAssertFalse(Date(timeIntervalSinceNow: 1).trackable)
        XCTAssertTrue(Date(timeIntervalSinceNow: -1).trackable)
        XCTAssertTrue(Calendar.global.date(byAdding: .day, value: -1, to: .now)!.trackable)
        XCTAssertTrue(Calendar.global.date(byAdding: .day, value: -2, to: .now)!.trackable)
        XCTAssertTrue(Calendar.global.date(byAdding: .day, value: -3, to: .now)!.trackable)
        XCTAssertTrue(Calendar.global.date(byAdding: .day, value: -4, to: .now)!.trackable)
        XCTAssertTrue(Calendar.global.date(byAdding: .day, value: -5, to: .now)!.trackable)
        XCTAssertTrue(Calendar.global.date(byAdding: .day, value: -6, to: .now)!.trackable)
        XCTAssertFalse(Calendar.global.date(byAdding: .day, value: -7, to: .now)!.trackable)
        XCTAssertFalse(Calendar.global.date(byAdding: .day, value: 1, to: .now)!.trackable)
        XCTAssertFalse(Calendar.global.date(byAdding: .hour, value: 1, to: .now)!.trackable)
    }
}
