import XCTest
@testable import Selene

final class ObservatoryTests: XCTestCase {
    func testPhase() {
        let observatory = Observatory(coords: .init(latitude: 52.483343, longitude: 13.452053))
        XCTAssertEqual(.waxingCrescent, observatory.moon(for: .init(timeIntervalSince1970: 1577905200)).phase)
    }
    
    func testCache() {
        let observatory = Observatory(coords: .init(latitude: 52.483343, longitude: 13.452053))

        XCTAssertEqual(observatory.moon(for: .init(timeIntervalSince1970: 1577905200)),
                       observatory.moon(for: .init(timeIntervalSince1970: 1577905200)))
        XCTAssertEqual(1, observatory.cache.count)
    }
    
    func testFlattenTime() {
        let date0 = Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0))!
        
        let date1 = Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 5))!
        
        let date2 = Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 9))!
        
        let date3 = Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 16))!
        
        let date4 = Calendar.global.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 1,
                                                      hour: 0))!
        let observatory = Observatory(coords: .init(latitude: 52.483343, longitude: 13.452053))
        
        _ = observatory.moon(for: date0)
        _ = observatory.moon(for: date1)
        _ = observatory.moon(for: date2)
        _ = observatory.moon(for: date3)
        
        var count = observatory.cache.count
        XCTAssertEqual(1, count)
        
        _ = observatory.moon(for: date4)
        
        count = observatory.cache.count
        XCTAssertEqual(2, count)
    }
    
    func testFlattenCoordinates() {
        let coords0 = Coords(latitude: 52.48, longitude: 13.45)
        let coords1 = Coords(latitude: 52.49, longitude: 13.46)
        let coords2 = Coords(latitude: 52.47, longitude: 13.47)
        let coords3 = Coords(latitude: 52.46, longitude: 13.49)
        let coords4 = Coords(latitude: 52.5, longitude: 13.45)
        
        let observatory = Observatory(coords: coords0)
        XCTAssertTrue(observatory.equals(to: coords0))
        XCTAssertTrue(observatory.equals(to: coords1))
        XCTAssertTrue(observatory.equals(to: coords2))
        XCTAssertTrue(observatory.equals(to: coords3))
        XCTAssertFalse(observatory.equals(to: coords4))
    }
}
