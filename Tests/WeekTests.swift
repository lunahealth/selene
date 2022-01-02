import XCTest
@testable import Archivable
@testable import Selene

final class WeekTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testWeek() async {
        let observatory = Observatory(coords: .init(latitude: 52.483343, longitude: 13.452053))
        var archive = Archive()
        
//        XCTAssertEqual(1, observatory.week.count)
//        
//        archive.journal = [.init()]
//        XCTAssertEqual(1, observatory.week(with: archive).items.count)
//        
//        let today = Calendar.global.today
//        archive.journal = .init(repeating: .init(timestamp: today - 1000000), count: 50)
//        XCTAssertEqual(7, observatory.week(with: archive).items.count)
//        XCTAssertEqual(today, observatory.week(with: archive).items.last?.timestamp)
//        
//        archive.journal = .init(repeating: .init(timestamp: 0), count: 50)
//        XCTAssertEqual(7, observatory.week(with: archive).items.count)
//        XCTAssertEqual(today, observatory.week(with: archive).items.first?.timestamp)
//
//        archive.journal = .init(repeating: .init(timestamp: 0), count: 3)
//        XCTAssertEqual(4, observatory.week(with: archive).items.count)
//        XCTAssertEqual(today, observatory.week(with: archive).items.first?.timestamp)
    }
}
