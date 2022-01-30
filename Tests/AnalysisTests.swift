import XCTest
@testable import Archivable
@testable import Selene

final class AnalysisTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testEmpty() {
        XCTAssertTrue(archive.analysis.isEmpty)
    }
}
