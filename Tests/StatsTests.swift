import XCTest
@testable import Archivable
@testable import Selene

final class StatsTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testEmpty() async {
        let stats = await cloud.stats(since: .all, trait: .sleep)
        XCTAssertTrue(stats.isEmpty)
    }
    
    func testDistribution() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -200, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -100, to: .now)!
        let date3 = Calendar.global.date(byAdding: .day, value: -90, to: .now)!
        let date4 = Calendar.global.date(byAdding: .day, value: -8, to: .now)!
        let date5 = Calendar.global.date(byAdding: .day, value: -7, to: .now)!
        
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .top))
        await cloud.update(journal: .init(date: date2).with(trait: .period, level: .medium))
        await cloud.update(journal: .init(date: date3).with(trait: .period, level: .medium))
        await cloud.update(journal: .init(date: date4).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date5).with(trait: .period, level: .high))
        
        let stats = await cloud.stats(since: .all, trait: .period)
        
        XCTAssertEqual(.medium, stats[0].level)
        XCTAssertEqual(0.4, stats[0].percent)
        XCTAssertEqual(.top, stats[1].level)
        XCTAssertEqual(0.2, stats[1].percent)
        XCTAssertEqual(.high, stats[2].level)
        XCTAssertEqual(0.2, stats[2].percent)
        XCTAssertEqual(.low, stats[3].level)
        XCTAssertEqual(0.2, stats[3].percent)
        XCTAssertEqual(4, stats.count)
    }
    
    func testDistributionFortnight() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -200, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -100, to: .now)!
        let date3 = Calendar.global.date(byAdding: .day, value: -90, to: .now)!
        let date4 = Calendar.global.date(byAdding: .day, value: -8, to: .now)!
        let date5 = Calendar.global.date(byAdding: .day, value: -7, to: .now)!
        
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .top))
        await cloud.update(journal: .init(date: date2).with(trait: .period, level: .medium))
        await cloud.update(journal: .init(date: date3).with(trait: .period, level: .medium))
        await cloud.update(journal: .init(date: date4).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date5).with(trait: .period, level: .high))
        
        let stats = await cloud.stats(since: .fortnight, trait: .period)
        
        XCTAssertEqual(.high, stats[0].level)
        XCTAssertEqual(0.5, stats[0].percent)
        XCTAssertEqual(.low, stats[1].level)
        XCTAssertEqual(0.5, stats[1].percent)
        XCTAssertEqual(2, stats.count)
    }
}
