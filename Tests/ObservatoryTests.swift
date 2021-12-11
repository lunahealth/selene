import XCTest
@testable import Selene

final class ObservatoryTests: XCTestCase {
    private var observatory: Observatory!
    
    override func setUp() {
        observatory = .init()
    }
    
    func testPhase() async {
        let phase = await observatory.moon(at: .init(timeIntervalSince1970: 1577905200),
                                           on: .init(latitude: 52.483343, longitude: 13.452053)).phase
        XCTAssertEqual(.waxingCrescent, phase)
    }
}
