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
        _ = await observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                    coords: .init(latitude: 52.483343, longitude: 13.452053)))
        _ = await observatory.moon(input: .init(date: .init(timeIntervalSince1970: 1577905200),
                                                    coords: .init(latitude: 52.483343, longitude: 13.452053)))
        
        let count = await observatory.cache.count
        
        XCTAssertEqual(1, count)
    }
}
