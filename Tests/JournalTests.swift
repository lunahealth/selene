import XCTest
@testable import Selene

final class JournalTests: XCTestCase {
    func testTraits() {
        var journal = Journal()
        XCTAssertTrue(journal.traits.isEmpty)
        
        journal = journal.with(trait: .period, level: .medium)
        XCTAssertEqual(journal, journal.with(trait: .period, level: .medium))
        XCTAssertEqual(1, journal.traits.count)
        XCTAssertEqual(.period, journal.traits.first?.key)
        XCTAssertEqual(.medium, journal.traits.first?.value)
        
        journal = journal.with(trait: .period, level: .top)
        XCTAssertEqual(1, journal.traits.count)
        XCTAssertEqual(.period, journal.traits.first?.key)
        XCTAssertEqual(.top, journal.traits.first?.value)
        
        journal = journal.with(trait: .sleep, level: .low)
        XCTAssertEqual(2, journal.traits.count)
    }
    
    func testRemove() {
        XCTAssertTrue(Journal()
                        .with(trait: .period, level: .high)
                        .removing(trait: .period).traits.isEmpty)
    }
}
