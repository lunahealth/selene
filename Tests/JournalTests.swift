import XCTest
@testable import Selene

final class JournalTests: XCTestCase {
    func testTraits() {
        var journal = Journal()
        XCTAssertTrue(journal.traits.isEmpty)
        
        journal = journal.with(trait: .period, value: 5)
        XCTAssertEqual(1, journal.traits.count)
        XCTAssertEqual(.period, journal.traits.first?.key)
        XCTAssertEqual(5, journal.traits.first?.value)
        
        journal = journal.with(trait: .period, value: 15)
        XCTAssertEqual(1, journal.traits.count)
        XCTAssertEqual(.period, journal.traits.first?.key)
        XCTAssertEqual(15, journal.traits.first?.value)
        
        journal = journal.with(trait: .sleep, value: 3)
        XCTAssertEqual(2, journal.traits.count)
    }
    
    func testCap() {
        XCTAssertEqual(5, Journal().with(trait: .period, value: 5).traits[.period])
        XCTAssertEqual(0, Journal().with(trait: .period, value: -1).traits[.period])
        XCTAssertEqual(0, Journal().with(trait: .period, value: -0.5).traits[.period])
        XCTAssertEqual(100, Journal().with(trait: .period, value: 100.1).traits[.period])
        XCTAssertEqual(100, Journal().with(trait: .period, value: 101).traits[.period])
        XCTAssertEqual(6, Journal().with(trait: .period, value: 5.6).traits[.period])
    }
    
    func testRemove() {
        XCTAssertTrue(Journal()
                        .with(trait: .period, value: 5)
                        .remove(trait: .period).traits.isEmpty)
    }
}
