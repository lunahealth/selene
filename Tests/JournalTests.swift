import XCTest
@testable import Archivable
@testable import Selene

final class JournalTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testWeek() async {
        XCTAssertEqual(1, archive.week.count)
        
        archive.journal = [.init()]
        XCTAssertEqual(1, archive.week.count)
        
        let today = Calendar.global.today
        archive.journal = .init(repeating: .init(timestamp: today - 1000000), count: 50)
        XCTAssertEqual(7, archive.week.count)
        XCTAssertEqual(today, archive.week.last?.timestamp)
        
        archive.journal = .init(repeating: .init(timestamp: 0), count: 50)
        XCTAssertEqual(7, archive.week.count)
        XCTAssertEqual(today, archive.week.first?.timestamp)

        archive.journal = .init(repeating: .init(timestamp: 0), count: 3)
        XCTAssertEqual(4, archive.week.count)
        XCTAssertEqual(today, archive.week.first?.timestamp)
    }
}
