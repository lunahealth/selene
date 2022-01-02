import XCTest
@testable import Selene

final class EntryTests: XCTestCase {
    func testCap() {
        XCTAssertEqual(5, Entry(trait: .period, value: 5).value)
        XCTAssertEqual(0, Entry(trait: .period, value: -1).value)
        XCTAssertEqual(0, Entry(trait: .period, value: -0.5).value)
        XCTAssertEqual(100, Entry(trait: .period, value: 100.1).value)
        XCTAssertEqual(100, Entry(trait: .period, value: 101).value)
        XCTAssertEqual(6, Entry(trait: .period, value: 5.6).value)
    }
}
