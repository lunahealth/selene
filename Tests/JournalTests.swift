import XCTest
@testable import Archivable
@testable import Selene

final class JournalTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testWeek() async {
        XCTAssertTrue(archive.week.isEmpty)
        
        archive.journal = [.init()]
        
        XCTAssertTrue(1, archive.week.count)
        
        archive.journal = .init(repeating: .init(), count: 50)
        
        XCTAssertTrue(7, archive.week.count)
    }
}
