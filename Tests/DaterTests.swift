import XCTest
@testable import Archivable
@testable import Selene

final class DaterTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testJournals() {
        let date1 = Calendar.global.date(from: .init(year: 2021, month: 1, day: 3))!
        let date2 = Calendar.global.date(from: .init(year: 2021, month: 1, day: 7, hour: 2))!
        archive.replace(item: .init(date: date1))
        archive.replace(item: .init(date: date2).with(trait: .period, level: .high))
        let month = archive
            .calendar
            .flatMap {
                $0
                    .items
                    .flatMap {
                        $0
                    }
            }
        
        XCTAssertTrue(month.first!.content.traits.isEmpty)
        XCTAssertTrue(month[2].content.traits.isEmpty)
        XCTAssertEqual(.period, month[6].content.traits.first?.key)
        XCTAssertEqual(.high, month[6].content.traits.first?.value)
    }
    
    func testMultipleMonths() {
        (0 ..< 10)
            .forEach { index in
                archive.replace(item: .init(date: Calendar.global.date(byAdding: .month, value: -(index), to: .now)!)
                                    .with(trait: .period, level: .high))
            }
        
        
        (0 ..< 10)
            .forEach { _ in
                XCTAssertEqual(10, archive.calendar.count)
            }
    }
}
