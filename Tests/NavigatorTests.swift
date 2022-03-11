import XCTest
@testable import Selene

final class NavigatorTests: XCTestCase {
    func testRadians() {
        var moon = Moon(inclination: .pi, apparentAngle: 1)
        
        XCTAssertEqual(.new, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi2, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0, maxWidth: 0).radians)
        
        moon = .init(inclination: 0, apparentAngle: 0)
        
        XCTAssertEqual(.full, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0, maxWidth: 0).radians)
        
        moon = .init(inclination: .pi_2, apparentAngle: -1)
        
        XCTAssertEqual(.firstQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi_2, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0, maxWidth: 0).radians)
        
        moon = .init(inclination: .pi_2, apparentAngle: 1)
        
        XCTAssertEqual(.lastQuarter, Moon.Phase(inclination: moon.inclination, angle: moon.apparentAngle))
        XCTAssertEqual(.pi_2 + .pi, Wheel(date: .now, moon: moon, correction: 0, size: .zero, padding: 0, maxWidth: 0).radians)
    }
    
    func testSize() {
        let date = Date()
        let moon = Moon(inclination: .pi, apparentAngle: 1)
        let wheel = Wheel(date: date, moon: moon, correction: 0, size: .init(width: 1000, height: 1000), padding: 0, maxWidth: 550)
        
        XCTAssertEqual(275, wheel.side)
    }
    
    func testMove() {
        let date = Date()
        let moon = Moon(inclination: .pi, apparentAngle: 1)
        let wheel = Wheel(date: date, moon: moon, correction: 0, size: .init(width: 1000, height: 1000), padding: 0, maxWidth: 1000)
        
        XCTAssertNil(wheel.move(point: wheel.origin))
        
        XCTAssertEqual(-15,
                       Calendar.global.dateComponents([.day], from: date, to: wheel.date(for: .init(x: -1000, y: 500))).day!)
    }
    
    func testMoveWithRadians() {
        let date = Date()
        let moon = Moon(inclination: .pi, apparentAngle: 1)
        let wheel = Wheel(date: date, moon: moon, correction: 0, size: .zero, padding: 0, maxWidth: 0)
        
        XCTAssertEqual(date,
                       wheel.move(radians: 0))
        
        XCTAssertEqual(0,
                       Calendar.global.dateComponents([.day], from: date, to: wheel.move(radians: 0.49 / 29.53 * .pi2)).day!)
        
        XCTAssertEqual(1,
                       Calendar.global.dateComponents([.day], from: date, to: wheel.move(radians: 0.51 / 29.53 * .pi2)).day!)
        
        XCTAssertEqual(1,
                       Calendar.global.dateComponents([.day], from: date, to: wheel.move(radians: 1.1 / 29.53 * .pi2)).day!)
        
        XCTAssertEqual(55,
                       Calendar.global.dateComponents([.day], from: date, to: wheel.move(radians: 55.4 / 29.53 * .pi2)).day!)
    }
    
    func testOrigin() {
        var moon = Moon(inclination: .pi, apparentAngle: 1)
        let size = CGSize(width: 1000, height: 1000)
        let padding = 20.0
        
        let wheel = Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000)
        XCTAssertEqual(.init(x: 980, y: 499.9999999999999), wheel.origin)
        
        XCTAssertEqual(980, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000).origin.x)
        XCTAssertEqual(499.9999999999999, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000).origin.y)
        
        moon = .init(inclination: 0, apparentAngle: 0)
        XCTAssertEqual(20, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000).origin.x)
        XCTAssertEqual(500.00000000000006, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000).origin.y)
        
        moon = .init(inclination: .pi_2, apparentAngle: -1)
        XCTAssertEqual(980, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000).origin.y)
        XCTAssertEqual(500.00000000000006, Wheel(date: .now, moon: moon, correction: 0, size: size, padding: padding, maxWidth: 1000).origin.x)
    }
    
    func testAccept() {
        let wheel = Wheel(date: .now, moon: .init(), correction: 0, size: .init(width: 1000, height: 1000), padding: 0, maxWidth: 1000)
        XCTAssertFalse(wheel.accept(point: .init(x: 0, y: 561)))
        XCTAssertFalse(wheel.accept(point: .init(x: 60, y: 500)))
        XCTAssertFalse(wheel.accept(point: .init(x: -60, y: 500)))
        XCTAssertFalse(wheel.accept(point: .init(x: 0, y: 440)))
        XCTAssertTrue(wheel.accept(point: .init(x: 0, y: 500)))
        XCTAssertTrue(wheel.accept(point: .init(x: 59, y: 559)))
        XCTAssertTrue(wheel.accept(point: .init(x: -59, y: 441)))
    }
    
    func testApproach() {
        let wheel = Wheel(date: Calendar.global.date(from: .init(year: 2022))!,
                          moon: .init(inclination: .pi, apparentAngle: 1),
                          correction: 0,
                          size: .init(width: 1000, height: 1000),
                          padding: 0, maxWidth: 1000)
        
        XCTAssertEqual(.init(x: 862.6871855061438,
                             y: 844.1772878468769),
                       wheel.approach(from: wheel.pointer(for: wheel.radians(for: .init(x: 1000, y: 1000)))))
        
        XCTAssertEqual(.init(x: 308.65828381745513,
                             y: 961.9397662556433),
                       wheel.approach(from: wheel.pointer(for: wheel.radians(for: .init(x: 0, y: 1000)))))
    }
    
    func testApproachFromDifferent() {
        let wheel = Wheel(date: Calendar.global.date(from: .init(year: 2022))!,
                          moon: .init(inclination: .pi, apparentAngle: 1),
                          correction: 0,
                          size: .init(width: 1000, height: 1000),
                          padding: 0, maxWidth: 1000)
        
        XCTAssertEqual(.init(x: 50,
                             y: 24.999999999999993),
                       wheel.approach(from: .zero))
    }
    
    func testApproachFromDifferentSmallDelta() {
        let wheel = Wheel(date: Calendar.global.date(from: .init(year: 2022))!,
                          moon: .init(inclination: .pi, apparentAngle: 1),
                          correction: 0,
                          size: .init(width: 1000, height: 1000),
                          padding: 0, maxWidth: 1000)
        var point = wheel.pointer(for: wheel.radians(for: .zero))
        point.x += 6
        XCTAssertEqual(.init(x: 311.9574019758561,
                             y: 36.707455997476416),
                       wheel.approach(from: point))
    }
    
    func testTrack() {
        let wheel = Tracker()
        
        XCTAssertEqual(.init(x: 65,
                             y: 65),
                       wheel.approach(from: .init(x: 65, y: 65)))
        
        XCTAssertEqual(.init(x: -281.75,
                             y: -281.75),
                       wheel.approach(from: .init(x: -300, y: -300)))
        
        XCTAssertEqual(.init(x: 288.25,
                             y: 288.25),
                       wheel.approach(from: .init(x: 300, y: 300)))
    }
}
