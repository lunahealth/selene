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
        
        archive.settings = .init(traits: [.init(trait: .period, active: true), .init(trait: .sleep, active: false)])
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(.period, archive.settings.traits.first?.id)
        XCTAssertTrue(archive.settings.traits.first!.active)
        XCTAssertEqual(.sleep, archive.settings.traits.last?.id)
        XCTAssertFalse(archive.settings.traits.last!.active)
        
        archive.coords = .init(latitude: 5.4321, longitude: -1.2345)
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(5.4, archive.coords.latitude)
        XCTAssertEqual(-1.2, archive.coords.longitude)
    }
    
    func testJournal() {
        let timezone = Calendar.global.timeZone
        
        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        let dateBerlin = Calendar
            .global
            .date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 0))!
        let dayBerlin = Day(id: dateBerlin, moon: .init(), journal: dateBerlin.journal)
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        let dateMexico = Calendar
            .global
            .date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 2, hour: 0))!
        let dayMexico = Day(id: dateMexico, moon: .init(), journal: dateMexico.journal)
        
        XCTAssertNil(archive.journal[dayMexico.journal]?.traits.isEmpty)
        
        archive.journal = [dayBerlin.journal : .init()]
        XCTAssertTrue(archive.journal[dayMexico.journal]!.traits.isEmpty)
        
        archive.journal = [dayBerlin.journal : Journal().with(trait: .period, value: 99)]
        XCTAssertEqual(.period, archive.journal[dayMexico.journal]!.traits.first?.key)
        XCTAssertEqual(99, archive.journal[dayMexico.journal]!.traits.first?.value)
        
        Calendar.global.timeZone = timezone
    }
}
