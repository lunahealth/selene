import XCTest
@testable import Archivable
@testable import Selene

final class StatsTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testEmpty() async {
        let stats = await cloud.stats(trait: .sleep)
        XCTAssertNil(stats)
    }
    
    func testCount() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -200, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -1, to: .now)!
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date2).with(trait: .period, level: .low))
        
        let stats = await cloud.stats(trait: .period)
        
        XCTAssertEqual(2, stats?.count)
    }
    
    func testRecent() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -200, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -1, to: .now)!
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date2).with(trait: .period, level: .medium))
        await cloud.track(trait: .period, level: .high)
        
        let stats = await cloud.stats(trait: .period)
        
        XCTAssertEqual(.high, stats?.recent)
    }
    
    func testDistribution() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -200, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -10, to: .now)!
        let date3 = Calendar.global.date(byAdding: .day, value: -9, to: .now)!
        let date4 = Calendar.global.date(byAdding: .day, value: -8, to: .now)!
        let date5 = Calendar.global.date(byAdding: .day, value: -7, to: .now)!
        
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .top))
        await cloud.update(journal: .init(date: date2).with(trait: .period, level: .medium))
        await cloud.update(journal: .init(date: date3).with(trait: .period, level: .medium))
        await cloud.update(journal: .init(date: date4).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date5).with(trait: .period, level: .high))
        
        let stats = await cloud.stats(trait: .period)?.distribution
        
        XCTAssertEqual(.medium, stats?[0].level)
        XCTAssertEqual(0.4, stats?[0].percent)
        XCTAssertEqual(.top, stats?[1].level)
        XCTAssertEqual(0.2, stats?[1].percent)
        XCTAssertEqual(.high, stats?[2].level)
        XCTAssertEqual(0.2, stats?[2].percent)
        XCTAssertEqual(.low, stats?[3].level)
        XCTAssertEqual(0.2, stats?[3].percent)
    }
}
