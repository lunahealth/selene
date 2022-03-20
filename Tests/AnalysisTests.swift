import XCTest
@testable import Archivable
@testable import Selene

final class AnalysisTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testEmpty() async {
        var analysis = await cloud.analysis(since: .all) { _ in fatalError() }
        XCTAssertTrue(analysis.isEmpty)
        
        await cloud.toggle(trait: .period, mode: true)
        await cloud.toggle(trait: .sleep, mode: true)
        
        analysis = await cloud.analysis(since: .all) { _ in fatalError() }
        XCTAssertNotNil(analysis[.period])
        XCTAssertNotNil(analysis[.sleep])
        XCTAssertTrue(analysis[.period]?.isEmpty ?? false)
        XCTAssertTrue(analysis[.sleep]?.isEmpty ?? false)
    }
    
    func testSimple() async {
        await cloud.toggle(trait: .period, mode: true)
        await cloud.track(trait: .period, level: .medium)
        
        let analysis = await cloud.analysis(since: .all) { _ in .firstQuarter }
        
        XCTAssertEqual(.medium, analysis[.period]?[.firstQuarter])
    }
    
    func testTracked() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -1, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -2, to: .now)!
        let date3 = Calendar.global.date(byAdding: .day, value: -3, to: .now)!
        let date4 = Calendar.global.date(byAdding: .day, value: -4, to: .now)!
        let date5 = Calendar.global.date(byAdding: .day, value: -5, to: .now)!
        let date6 = Calendar.global.date(byAdding: .day, value: -6, to: .now)!
        
        let phases = [
            date1.timestamp : Moon.Phase.firstQuarter,
            date2.timestamp : Moon.Phase.full,
            date3.timestamp : Moon.Phase.waningCrescent,
            date4.timestamp : Moon.Phase.firstQuarter,
            date5.timestamp : Moon.Phase.firstQuarter,
            date6.timestamp : Moon.Phase.firstQuarter,]
        
        await cloud.toggle(trait: .period, mode: true)
        await cloud.toggle(trait: .exercise, mode: true)
        await cloud.toggle(trait: .sleep, mode: true)
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .low).with(trait: .exercise, level: .top))
        await cloud.update(journal: .init(date: date2).with(trait: .sleep, level: .low))
        await cloud.update(journal: .init(date: date3).with(trait: .period, level: .bottom))
        await cloud.update(journal: .init(date: date4).with(trait: .period, level: .bottom))
        
        var analysis = await cloud.analysis(since: .all) { phases[$0.timestamp]! }
        
        XCTAssertEqual(.low, analysis[.period]?[.firstQuarter])
        XCTAssertEqual(.top, analysis[.exercise]?[.firstQuarter])
        XCTAssertEqual(.low, analysis[.sleep]?[.full])
        XCTAssertEqual(.bottom, analysis[.period]?[.waningCrescent])
        
        await cloud.update(journal: .init(date: date5).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date6).with(trait: .period, level: .medium))
        
        analysis = await cloud.analysis(since: .all) { phases[$0.timestamp]! }
        
        XCTAssertEqual(.low, analysis[.period]?[.firstQuarter])
    }
    
    func testLastMonth() async {
        let date1 = Calendar.global.date(byAdding: .month, value: -2, to: .now)!
        let date2 = Calendar.global.date(byAdding: .month, value: -3, to: .now)!
        let date3 = Calendar.global.date(byAdding: .day, value: -3, to: .now)!
        
        let phases = [
            date1.timestamp : Moon.Phase.firstQuarter,
            date2.timestamp : Moon.Phase.full,
            date3.timestamp : Moon.Phase.waningCrescent]
        
        await cloud.toggle(trait: .period, mode: true)
        await cloud.toggle(trait: .exercise, mode: true)
        await cloud.toggle(trait: .sleep, mode: true)
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date2).with(trait: .exercise, level: .low))
        await cloud.update(journal: .init(date: date3).with(trait: .sleep, level: .bottom))
        
        let analysis = await cloud.analysis(since: .month) { phases[$0.timestamp]! }
        
        XCTAssertNil(analysis[.period]?[.firstQuarter])
        XCTAssertNil(analysis[.exercise]?[.full])
        XCTAssertEqual(.bottom, analysis[.sleep]?[.waningCrescent])
    }
    
    func testFortnight() async {
        let date1 = Calendar.global.date(byAdding: .day, value: -20, to: .now)!
        let date2 = Calendar.global.date(byAdding: .day, value: -10, to: .now)!
        let date3 = Calendar.global.date(byAdding: .day, value: -3, to: .now)!
        
        let phases = [
            date1.timestamp : Moon.Phase.firstQuarter,
            date2.timestamp : Moon.Phase.full,
            date3.timestamp : Moon.Phase.waningCrescent]
        
        await cloud.toggle(trait: .period, mode: true)
        await cloud.toggle(trait: .exercise, mode: true)
        await cloud.toggle(trait: .sleep, mode: true)
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .low))
        await cloud.update(journal: .init(date: date2).with(trait: .exercise, level: .low))
        await cloud.update(journal: .init(date: date3).with(trait: .sleep, level: .bottom))
        
        let analysis = await cloud.analysis(since: .fortnight) { phases[$0.timestamp]! }
        
        XCTAssertNil(analysis[.period]?[.firstQuarter])
        XCTAssertEqual(.low, analysis[.exercise]?[.full])
        XCTAssertEqual(.bottom, analysis[.sleep]?[.waningCrescent])
    }
    
    func testIgnoreNotActive() async {
        await cloud.toggle(trait: .sleep, mode: true)
        await cloud.track(trait: .period, level: .medium)
        
        let analysis = await cloud.analysis(since: .all) { _ in .firstQuarter }
        
        XCTAssertTrue(analysis[.sleep]?.isEmpty ?? false)
        XCTAssertNil(analysis[.period])
    }
}
