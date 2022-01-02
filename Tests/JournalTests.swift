import XCTest
@testable import Selene

final class JournalTests: XCTestCase {
    func testTraits() {
        var journal = Journal(gmt: 0)
        XCTAssertTrue(journal.entries.isEmpty)
        
        journal = journal.with(entry: .init(trait: .period, value: 5))
        XCTAssertEqual(1, journal.entries.count)
        XCTAssertEqual(.period, journal.entries.first?.trait)
        XCTAssertEqual(5, journal.entries.first?.value)
        
        journal = journal.with(entry: .init(trait: .period, value: 15))
        XCTAssertEqual(1, journal.entries.count)
        XCTAssertEqual(.period, journal.entries.first?.trait)
        XCTAssertEqual(15, journal.entries.first?.value)
        
        journal = journal.with(entry: .init(trait: .sleep, value: 3))
        XCTAssertEqual(2, journal.entries.count)
    }
}
