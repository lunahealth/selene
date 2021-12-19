import XCTest
@testable import Selene

final class MoonTests: XCTestCase {
    func testVisible() {
        XCTAssertTrue(Moon().visible)
        XCTAssertTrue(Moon(altitude: .pi / 2).visible)
        XCTAssertTrue(Moon(altitude: .pi).visible)
        XCTAssertTrue(Moon(altitude: .pi * 0.01).visible)
        XCTAssertFalse(Moon(altitude: .pi * 1.01).visible)
        XCTAssertFalse(Moon(altitude: .pi * 2).visible)
        XCTAssertFalse(Moon(altitude: -0.01).visible)
    }
}
