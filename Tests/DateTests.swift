import XCTest
@testable import Selene

final class DateTests: XCTestCase {
    func testJulianDay() {
        XCTAssertEqual(-0.5, Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0), year: 2000))?.julianDay)
    }
    
    func testGmtDay() {
        let timezone = Calendar.global.timeZone

        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        
        let date1 = Calendar
            .global
            .journal(from: Calendar
                        .global
                        .date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 1))!)
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        
        let date2 = Calendar
            .global
            .journal(from: Calendar
                        .global
                        .date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 2, hour: 1))!)
        
        XCTAssertTrue(Calendar.global.isDate(date1, inSameDayAs: date2))
        Calendar.global.timeZone = timezone
    }
    
    func testGmtDayDifference() {
        let date1 = Calendar
            .global
            .journal(from: Calendar
                        .global
                        .date(from: .init(year: 2021, month: 1, day: 2, hour: 0))!)
        
        let date2 = Calendar
            .global
            .journal(from: Calendar
                        .global
                        .date(from: .init(year: 2021, month: 1, day: 2, hour: 1))!)
        
        let date3 = Calendar
            .global
            .journal(from: Calendar
                        .global
                        .date(from: .init(year: 2021, month: 1, day: 2, hour: 22))!)
        
        XCTAssertEqual(date1, date2)
        XCTAssertEqual(date1, date3)
    }
}
