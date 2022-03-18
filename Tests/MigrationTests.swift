import XCTest
@testable import Archivable
@testable import Selene

final class MigrationTests: XCTestCase {
    private var archive: Archive_v1!
    
    override func setUp() {
        archive = .init()
        UserDefaults(suiteName: "group.moonhealth.share")!.removeObject(forKey: Defaults.coords.rawValue)
    }
    
    override func tearDown() {
        UserDefaults(suiteName: "group.moonhealth.share")!.removeObject(forKey: Defaults.coords.rawValue)
    }
    
    func testMigrate() async {
        let date = Date(timeIntervalSinceNow: -100000)
        archive.replace(item: .init(date: date)
                            .with(trait: .period, level: .high)
                            .with(trait: .sleep, level: .low))
        archive.coords = .init(latitude: 5.4321, longitude: -1.2345)
        archive.settings = archive.settings.adding(trait: .period).adding(trait: .sleep)

        XCTAssertNil(Defaults.coordinates)
        
        let migrated = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(1, migrated.journal.count)
        XCTAssertEqual(2, migrated.journal.first?.traits.count)
        XCTAssertEqual(.high, migrated.journal.first?.traits.first { $0.key == .period }?.value)
        XCTAssertEqual(.low, migrated.journal.first?.traits.first { $0.key == .sleep }?.value)
        XCTAssertEqual(date.timestamp, migrated.journal.first?.date.timestamp)
        XCTAssertTrue(Calendar.global.isDate(archive.journal.first!.date, inSameDayAs: date))
        XCTAssertTrue(migrated.settings.traits.contains(.period))
        XCTAssertTrue(migrated.settings.traits.contains(.sleep))
        XCTAssertFalse(migrated.settings.traits.contains(.exercise))
        
        let coords = Defaults.coordinates
        XCTAssertEqual(5.4321, coords?.latitude)
        XCTAssertEqual(-1.2345, coords?.longitude)
    }
}
