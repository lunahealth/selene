import XCTest
@testable import Selene

final class ObservatoryTests: XCTestCase {
    private var observatory: Observatory!
    
    override func setUp() {
        observatory = .init()
    }
    
    func testPhase() {
        let phase = observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                        coords: .init(latitude: 52.483343, longitude: 13.452053)))
            .phase
        XCTAssertEqual(.waxingCrescent, phase)
    }
    
    func testCache() {
        let a = observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                    coords: .init(latitude: 52.483343, longitude: 13.452053)))
        let b = observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                    coords: .init(latitude: 52.483343, longitude: 13.452053)))
        let count = observatory.cache.count
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(1, count)
    }
    
    func testFlattenTime() {
        let date0 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0))!
        
        let date1 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 5))!
        
        let date2 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 9))!
        
        let date3 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 16))!
        
        let date4 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 1,
                                                      hour: 0))!
        let coords = Coords(latitude: 52.483343, longitude: 13.452053)
        
        _ = observatory.moon(input: .init(date: date0, coords: coords))
        _ = observatory.moon(input: .init(date: date1, coords: coords))
        _ = observatory.moon(input: .init(date: date2, coords: coords))
        _ = observatory.moon(input: .init(date: date3, coords: coords))
        
        var count = observatory.cache.count
        XCTAssertEqual(1, count)
        
        _ = observatory.moon(input: .init(date: date4, coords: coords))
        
        count = observatory.cache.count
        XCTAssertEqual(2, count)
    }
    
    func testFlattenCoordinates() {
        let date = Date.now
        let coords0 = Coords(latitude: 52.48, longitude: 13.45)
        let coords1 = Coords(latitude: 52.49, longitude: 13.46)
        let coords2 = Coords(latitude: 52.47, longitude: 13.47)
        let coords3 = Coords(latitude: 52.46, longitude: 13.49)
        let coords4 = Coords(latitude: 52.5, longitude: 13.45)
        
        _ = observatory.moon(input: .init(date: date, coords: coords0))
        _ = observatory.moon(input: .init(date: date, coords: coords1))
        _ = observatory.moon(input: .init(date: date, coords: coords2))
        _ = observatory.moon(input: .init(date: date, coords: coords3))
        
        var count = observatory.cache.count
        XCTAssertEqual(1, count)
        
        _ = observatory.moon(input: .init(date: date, coords: coords4))
        
        count = observatory.cache.count
        XCTAssertEqual(2, count)
    }
}
