import XCTest
@testable import Selene

final class PhaseTests: XCTestCase {
    func testInclinationAndAngle() {
        XCTAssertEqual(., Moon.Phase(inclination: Double, angle: Double))
    }
}
