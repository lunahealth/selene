import XCTest
@testable import Selene

final class WheelTests: XCTestCase {
    func testProgress() {
        var moon = Moon(inclination: .pi, parallacticAngle: 1)
        
        XCTAssertEqual(.new, Moon.Phase(inclination: moon.inclination, angle: moon.parallacticAngle))
        XCTAssertEqual(.pi2, Wheel(date: .now, moon: moon).progress)
        
        moon = .init(inclination: 0, parallacticAngle: 0)
        
        XCTAssertEqual(.full, Moon.Phase(inclination: moon.inclination, angle: moon.parallacticAngle))
        XCTAssertEqual(.pi, Wheel(date: .now, moon: moon).progress)
        
        moon = .init(inclination: .pi_2, parallacticAngle: -1)
        
        XCTAssertEqual(.firstQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.parallacticAngle))
        XCTAssertEqual(.pi_2, Wheel(date: .now, moon: moon).progress)
        
        moon = .init(inclination: .pi_2, parallacticAngle: 1)
        
        XCTAssertEqual(.lastQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.parallacticAngle))
        XCTAssertEqual(.pi_2 + .pi, Wheel(date: .now, moon: moon).progress)
    }
    
    func testProgressing() {
//        let original = Moon(
    }
}
