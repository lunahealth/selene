import XCTest
@testable import Archivable
@testable import Selene

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testDifferentVersion() async {
        archive.replace(item: .init(date: .init(timeIntervalSinceNow: -1000))
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low)
                            .with(trait: .exercise, level: .low)
                            .with(trait: .focus, level: .low))
        
        archive.replace(item: .init(date: .init(timeIntervalSinceNow: -100000))
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low)
                            .with(trait: .exercise, level: .low)
                            .with(trait: .focus, level: .low))
        
        archive.replace(item: .init(date: .init(timeIntervalSinceNow: -10000000))
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low)
                            .with(trait: .exercise, level: .low)
                            .with(trait: .focus, level: .low))
        
        archive.replace(item: .init(date: .init(timeIntervalSinceNow: -20000000))
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low)
                            .with(trait: .exercise, level: .low)
                            .with(trait: .focus, level: .low))
        
        archive.replace(item: .init(date: .init(timeIntervalSinceNow: -30000000))
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low)
                            .with(trait: .exercise, level: .low)
                            .with(trait: .focus, level: .low))
        
        archive.replace(item: .init(date: .init(timeIntervalSinceNow: -40000000))
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low)
                            .with(trait: .exercise, level: .low)
                            .with(trait: .focus, level: .low))
        
        let parsed = await Archive(version: 0, timestamp: archive.timestamp, data: archive.data)
        XCTAssertTrue(parsed.journal.isEmpty)
    }
    
    func testParse() async {
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertTrue(archive.journal.isEmpty)
        
        let date = Date(timeIntervalSinceNow: -100000)
        archive.replace(item: .init(date: date)
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low))

        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual(1, archive.journal.count)
        XCTAssertEqual(2, archive.journal.first?.traits.count)
        XCTAssertEqual(.high, archive.journal.first?.traits.first { $0.key == .period }?.value)
        XCTAssertEqual(.low, archive.journal.first?.traits.first { $0.key == .sleep }?.value)
        XCTAssertEqual(date.timestamp, archive.journal.first?.date.timestamp)
        XCTAssertTrue(Calendar.global.isDate(archive.journal.first!.date, inSameDayAs: date))
        
        archive.replace(item: .init(date: date))
        archive.replace(item: .init(date: .now))
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertEqual(2, archive.journal.count)
        
        archive.settings = archive.settings.adding(trait: .period).adding(trait: .sleep)
        archive = await Archive(version: Archive.version, timestamp: archive.timestamp, data: archive.data)
        XCTAssertTrue(archive.settings.traits.contains(.period))
        XCTAssertTrue(archive.settings.traits.contains(.sleep))
        XCTAssertFalse(archive.settings.traits.contains(.exercise))
    }
    
    func testJournal() {
        let timezone = Calendar.global.timeZone
        
        let berlin = TimeZone(identifier: "Europe/Berlin")!
        Calendar.global.timeZone = berlin
        let dateBerlin = Calendar
            .global
            .date(from: .init(timeZone: berlin, year: 2021, month: 1, day: 2, hour: 0))!
        
        let mexico = TimeZone(identifier: "America/Mexico_City")!
        Calendar.global.timeZone = mexico
        let dateMexico = Calendar
            .global
            .date(from: .init(timeZone: mexico, year: 2021, month: 1, day: 2, hour: 0))!
        
        XCTAssertNil(archive[dateMexico]?.traits.isEmpty)
        XCTAssertNil(archive[dateBerlin]?.traits.isEmpty)
        
        archive.replace(item: .init(date: dateBerlin))
        XCTAssertTrue(archive[dateBerlin]!.traits.isEmpty)
        XCTAssertNil(archive[dateMexico]?.traits.isEmpty)
        
        archive.replace(item: .init(date: dateMexico).with(trait: .period, level: .top))
        XCTAssertEqual(.period, archive[dateMexico]?.traits.first?.key)
        XCTAssertEqual(.top, archive[dateMexico]?.traits.first?.value)
        
        Calendar.global.timeZone = timezone
    }
}
