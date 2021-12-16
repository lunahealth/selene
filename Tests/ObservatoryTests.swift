import XCTest
@testable import Selene

final class ObservatoryTests: XCTestCase {
    private var observatory: Observatory!
    
    override func setUp() {
        observatory = .init()
    }
    
    func testPhase() async {
        let phase = await observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                        coords: .init(latitude: 52.483343, longitude: 13.452053)))
            .phase
        XCTAssertEqual(.waxingCrescent, phase)
    }
    
    func testCache() async {
        let a = await observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                    coords: .init(latitude: 52.483343, longitude: 13.452053)))
        let b = await observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                    coords: .init(latitude: 52.483343, longitude: 13.452053)))
        let count = await observatory.cache.count
        
        XCTAssertEqual(a, b)
        XCTAssertEqual(1, count)
    }
    
    func testFlattenTime() async {
        let date0 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0,
                                                      minute: 0,
                                                      second: 0))!
        
        let date1 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0,
                                                      minute: 0,
                                                      second: 30))!
        
        let date2 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0,
                                                      minute: 3,
                                                      second: 20))!
        
        let date3 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0,
                                                      minute: 4,
                                                      second: 50))!
        
        let date4 = Calendar.current.date(from: .init(timeZone: .init(secondsFromGMT: 0),
                                                      year: 2001,
                                                      month: 0,
                                                      day: 0,
                                                      hour: 0,
                                                      minute: 5,
                                                      second: 0))!
        let coords = Coords(latitude: 52.483343, longitude: 13.452053)
        
        _ = await observatory.moon(input: .init(date: date0, coords: coords))
        _ = await observatory.moon(input: .init(date: date1, coords: coords))
        _ = await observatory.moon(input: .init(date: date2, coords: coords))
        _ = await observatory.moon(input: .init(date: date3, coords: coords))
        
        var count = await observatory.cache.count
        XCTAssertEqual(1, count)
        
        _ = await observatory.moon(input: .init(date: date4, coords: coords))
        
        count = await observatory.cache.count
        XCTAssertEqual(2, count)
    }
    
    func testFlattenCoordinates() async {
        let date = Date.now
        let coords0 = Coords(latitude: 52.483343, longitude: 13.452053)
        let coords1 = Coords(latitude: 52.489, longitude: 13.45)
        let coords2 = Coords(latitude: 52.483, longitude: 13.45)
        let coords3 = Coords(latitude: 52.483999, longitude: 13.452999)
        let coords4 = Coords(latitude: 52.493343, longitude: 13.452053)
        
        _ = await observatory.moon(input: .init(date: date, coords: coords0))
        _ = await observatory.moon(input: .init(date: date, coords: coords1))
        _ = await observatory.moon(input: .init(date: date, coords: coords2))
        _ = await observatory.moon(input: .init(date: date, coords: coords3))
        
        var count = await observatory.cache.count
        XCTAssertEqual(1, count)
        
        _ = await observatory.moon(input: .init(date: date, coords: coords4))
        
        count = await observatory.cache.count
        XCTAssertEqual(2, count)
    }
}
