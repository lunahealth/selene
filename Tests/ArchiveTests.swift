import XCTest
@testable import Archivable
@testable import Selene

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testParse() async {
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertTrue(archive.journal.isEmpty)
        
        archive.journal = [1 : .init()
                            .with(trait: .period, value: 55)
                            .with(trait: .sleep, value: 3)]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(1, archive.journal.count)
        XCTAssertEqual(1, archive.journal.first?.key)
        XCTAssertEqual(2, archive.journal.first?.value.traits.count)
        
        archive.journal = [1 : .init(), 2 : .init()]
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(2, archive.journal.count)
    }
    
    func testJournal() {
        let timezone = Calendar.global.timeZone
        
        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        let dateBerlin = Calendar
            .global
            .date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 0))!
        let dayBerlin = Day(id: dateBerlin.gmtDay, date: dateBerlin, moon: .init())
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        let dateMexico = Calendar
            .global
            .date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 2, hour: 0))!
        let dayMexico = Day(id: dateMexico.gmtDay, date: dateMexico, moon: .init())
        
        XCTAssertNil(archive.journal[dayMexico.id]?.traits.isEmpty)
        
        archive.journal = [dayBerlin.id : .init()]
        XCTAssertTrue(archive.journal[dayMexico.id]!.traits.isEmpty)
        
        archive.journal = [dayBerlin.id : Journal().with(trait: .period, value: 99)]
        XCTAssertEqual(.period, archive.journal[dayMexico.id]!.traits.first?.key)
        XCTAssertEqual(99, archive.journal[dayMexico.id]!.traits.first?.value)
        
        Calendar.global.timeZone = timezone
    }
}
