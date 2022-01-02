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
    
    func testGmtDay() {
        let timezone = Calendar.global.timeZone

        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        
        let date1 = Calendar
            .global
            .gmtDay(from: Calendar
                        .global
                        .date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 1))!)
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        
        let date2 = Calendar
            .global
            .gmtDay(from: Calendar
                        .global
                        .date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 2, hour: 1))!)
        
        XCTAssertTrue(Calendar.global.isDate(date1, inSameDayAs: date2))
        Calendar.global.timeZone = timezone
    }
}
