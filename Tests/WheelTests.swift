import XCTest
@testable import Selene

final class WheelTests: XCTestCase {
    func testRadians() {
        var moon = Moon(inclination: .pi, apparentAngle: 1)
        
        XCTAssertEqual(.new, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi2, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0).radians)
        
        moon = .init(inclination: 0, apparentAngle: 0)
        
        XCTAssertEqual(.full, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0).radians)
        
        moon = .init(inclination: .pi_2, apparentAngle: -1)
        
        XCTAssertEqual(.firstQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi_2, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0).radians)
        
        moon = .init(inclination: .pi_2, apparentAngle: 1)
        
        XCTAssertEqual(.lastQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi_2 + .pi, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0).radians)
    }
    
    func testMove() {
        let date = Date()
        let moon = Moon(inclination: .pi, apparentAngle: 1)
        let wheel = Wheel(date: date, moon: moon, correction: 0, size: .init(width: 1000, height: 1000), padding: 0)
        
        XCTAssertNil(wheel.move(point: wheel.origin))
        
        XCTAssertEqual(-15,
                       Calendar.current.dateComponents([.day], from: date, to: wheel.date(for: .init(x: -1000, y: 500))).day!)
    }
    
    func testMoveWithRadians() {
        let date = Date()
        let moon = Moon(inclination: .pi, apparentAngle: 1)
        let wheel = Wheel(date: date, moon: moon, correction: 0, size: .zero, padding: 0)
        
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
    
    func testOrigin() {
        var moon = Moon(inclination: .pi, apparentAngle: 1)
        let size = CGSize(width: 1000, height: 1000)
        let padding = 20.0
        
        let wheel = Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding)
        XCTAssertEqual(.init(x: 980, y: 499.9999999999999), wheel.origin)
        
        XCTAssertEqual(980, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding).origin.x)
        XCTAssertEqual(499.9999999999999, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding).origin.y)
        
        moon = .init(inclination: 0, apparentAngle: 0)
        XCTAssertEqual(20, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding).origin.x)
        XCTAssertEqual(500.00000000000006, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding).origin.y)
        
        moon = .init(inclination: .pi_2, apparentAngle: -1)
        XCTAssertEqual(980, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding).origin.y)
        XCTAssertEqual(500.00000000000006, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding).origin.x)
    }
    
    func testAccept() {
        let wheel = Wheel(date: .now, moon: .init(), correction: 0, size: .init(width: 1000, height: 1000), padding: 0)
        XCTAssertFalse(wheel.accept(point: .init(x: 0, y: 561)))
        XCTAssertFalse(wheel.accept(point: .init(x: 60, y: 500)))
        XCTAssertFalse(wheel.accept(point: .init(x: -60, y: 500)))
        XCTAssertFalse(wheel.accept(point: .init(x: 0, y: 440)))
        XCTAssertTrue(wheel.accept(point: .init(x: 0, y: 500)))
        XCTAssertTrue(wheel.accept(point: .init(x: 59, y: 559)))
        XCTAssertTrue(wheel.accept(point: .init(x: -59, y: 441)))
    }
    
    func testApproach() {
        let wheel = Wheel(date: .now,
                          moon: .init(inclination: .pi, apparentAngle: 1),
                          correction: 0,
                          size: .init(width: 1000, height: 1000),
                          padding: 0)
        
        XCTAssertEqual(.init(x: 999.8286624877786,
                             y: 486.9115258460632),
                       wheel.approach(from: .init(x: 1000, y: 1000)))
        
        XCTAssertEqual(.init(x: 998.458666866564,
                             y: 460.7704521360772),
                       wheel.approach(from: .init(x: 0, y: 1000)))
    }
}
