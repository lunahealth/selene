import XCTest
@testable import Selene

final class WheelTests: XCTestCase {
    func testRadians() {
        var moon = Moon(inclination: .pi, apparentAngle: 1)
        
        XCTAssertEqual(.new, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi2, Wheel(date: .now, moon: moon, correction: 0).radians)
        
        moon = .init(inclination: 0, apparentAngle: 0)
        
        XCTAssertEqual(.full, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi, Wheel(date: .now, moon: moon, correction: 0).radians)
        
        moon = .init(inclination: .pi_2, apparentAngle: -1)
        
        XCTAssertEqual(.firstQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi_2, Wheel(date: .now, moon: moon, correction: 0).radians)
        
        moon = .init(inclination: .pi_2, apparentAngle: 1)
        
        XCTAssertEqual(.lastQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi_2 + .pi, Wheel(date: .now, moon: moon, correction: 0).radians)
    }
    
    func testPoint() {
        var moon = Moon(inclination: .pi, apparentAngle: 1)
        XCTAssertEqual(1, Wheel(date: .now, moon: moon, correction: 0).point.x)
        XCTAssertGreaterThan(0.1, Wheel(date: .now, moon: moon, correction: 0).point.y)
        XCTAssertLessThan(-0.1, Wheel(date: .now, moon: moon, correction: 0).point.y)
        
        moon = .init(inclination: 0, apparentAngle: 0)
        XCTAssertEqual(-1, Wheel(date: .now, moon: moon, correction: 0).point.x)
        XCTAssertGreaterThan(0.1, Wheel(date: .now, moon: moon, correction: 0).point.y)
        XCTAssertLessThan(-0.1, Wheel(date: .now, moon: moon, correction: 0).point.y)
        
        moon = .init(inclination: .pi_2, apparentAngle: -1)
        XCTAssertEqual(1, Wheel(date: .now, moon: moon, correction: 0).point.y)
        XCTAssertGreaterThan(0.1, Wheel(date: .now, moon: moon, correction: 0).point.x)
        XCTAssertLessThan(-0.1, Wheel(date: .now, moon: moon, correction: 0).point.x)
    }
    
    func testMove() {
        let date = Date()
        let moon = Moon(inclination: .pi, apparentAngle: 1)
        let wheel = Wheel(date: date, moon: moon, correction: 0)
        
        XCTAssertEqual(date,
                       wheel.move(radians: 0))
        
        XCTAssertEqual(0,
                       Calendar.current.dateComponents([.day], from: date, to: wheel.move(radians: 0.49 / 29.53 * .pi2)).day!)
        
        XCTAssertEqual(1,
                       Calendar.current.dateComponents([.day], from: date, to: wheel.move(radians: 0.51 / 29.53 * .pi2)).day!)
        
        XCTAssertEqual(1,
                       Calendar.current.dateComponents([.day], from: date, to: wheel.move(radians: 1.1 / 29.53 * .pi2)).day!)
        
        XCTAssertEqual(55,
                       Calendar.current.dateComponents([.day], from: date, to: wheel.move(radians: 55.4 / 29.53 * .pi2)).day!)
    }
}
