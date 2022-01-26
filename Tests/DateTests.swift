import XCTest
@testable import Selene

final class DateTests: XCTestCase {
    func testJulianDay() {
        XCTAssertEqual(-0.5, Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0), year: 2000))?.julianDay)
    }
    
    func testTimezones() {
        var archive = Archive()
        let timezone = Calendar.global.timeZone

        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        let dateBerlin = Calendar.global.date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 1))!
        archive.replace(item: .init(date: dateBerlin).with(trait: .sleep, level: .top))
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        let dateMexico = Calendar.global.date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 3, hour: 22))!
        archive.replace(item: .init(date: dateMexico).with(trait: .period, level: .low))
        
        XCTAssertEqual(2, archive.journal.count)
        
        Calendar.global.timeZone = berlin
        let dateBerlin2 = Calendar.global.date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 23))!
        let dateBerlin3 = Calendar.global.date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 3, hour: 2))!
        
        XCTAssertEqual(.top, archive[dateBerlin2]?.traits[.sleep])
        XCTAssertEqual(.low, archive[dateBerlin3]?.traits[.period])
        
        Calendar.global.timeZone = mexico
        let dateMexico2 = Calendar.global.date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 2, hour: 23))!
        let dateMexico3 = Calendar.global.date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 3, hour: 2))!
        
        XCTAssertEqual(.top, archive[dateMexico2]?.traits[.sleep])
        XCTAssertEqual(.low, archive[dateMexico3]?.traits[.period])
        
        Calendar.global.timeZone = timezone
    }
}
