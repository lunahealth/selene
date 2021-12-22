import XCTest
@testable import Selene

final class MoonTests: XCTestCase {
    func testProgress() {
        var inclination = Double.pi
        var angle = 1.0
        
        XCTAssertEqual(.new, Moon.Phase(inclination: inclination, angle: angle))
        XCTAssertEqual(.pi2, Moon.progress(inclination: inclination, angle: angle))
        
        inclination = 0
        angle = 0
        
        XCTAssertEqual(.full, Moon.Phase(inclination: inclination, angle: angle))
        XCTAssertEqual(.pi, Moon.progress(inclination: inclination, angle: angle))
        
        inclination = .pi_2
        angle = -1
        
        XCTAssertEqual(.firstQuarter, Moon.Phase(inclination: inclination, angle: angle))
        XCTAssertEqual(.pi_2, Moon.progress(inclination: inclination, angle: angle))
        
        inclination = .pi_2
        angle = 1
        
        XCTAssertEqual(.lastQuarter, Moon.Phase(inclination: inclination, angle: angle))
        XCTAssertEqual(.pi_2 + .pi, Moon.progress(inclination: inclination, angle: angle))
    }
}
