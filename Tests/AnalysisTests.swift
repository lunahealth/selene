import XCTest
@testable import Archivable
@testable import Selene

final class AnalysisTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testEmpty() async {
        var analysis = await cloud.analysis { _ in fatalError() }
        XCTAssertTrue(analysis.isEmpty)
        
        await cloud.toggle(trait: .period, mode: true)
        await cloud.toggle(trait: .sleep, mode: true)
        
        analysis = await cloud.analysis { _ in fatalError() }
        XCTAssertNotNil(analysis[.period])
        XCTAssertNotNil(analysis[.sleep])
        XCTAssertTrue(analysis[.period]?.isEmpty ?? false)
        XCTAssertTrue(analysis[.sleep]?.isEmpty ?? false)
    }
    
    func testSimple() async {
        await cloud.toggle(trait: .period, mode: true)
        await cloud.track(trait: .period, level: .medium)
        
        let analysis = await cloud.analysis { _ in .firstQuarter }
        
        XCTAssertEqual(.medium, analysis[.period]?[.firstQuarter])
    }
    
    func testTracked() async {
        let date1 = Date(timeIntervalSinceNow: -1)
        let date2 = Date(timeIntervalSinceNow: -2)
        let date3 = Date(timeIntervalSinceNow: -3)
        let date4 = Date(timeIntervalSinceNow: -4)
        let date5 = Date(timeIntervalSinceNow: -5)
        let date6 = Date(timeIntervalSinceNow: -6)
        let date7 = Date(timeIntervalSinceNow: -7)
        let date8 = Date(timeIntervalSinceNow: -8)
        
        let phases = [
            date1.timestamp : Moon.Phase.firstQuarter,
            date2.timestamp : Moon.Phase.full,
            date3.timestamp : Moon.Phase.waningCrescent,
            date4.timestamp : Moon.Phase.full,
            date5.timestamp : Moon.Phase.full,
            date6.timestamp : Moon.Phase.full,
            date7.timestamp : Moon.Phase.full,
            date8.timestamp : Moon.Phase.full]
        
        await cloud.toggle(trait: .period, mode: true)
        await cloud.update(journal: .init(date: date1).with(trait: .period, level: .medium))
        
        var analysis = await cloud.analysis { phases[$0.timestamp]! }
        
        XCTAssertEqual(.medium, analysis[.period]?[.firstQuarter])
    }
    
    func testIgnoreNotActive() async {
        await cloud.toggle(trait: .sleep, mode: true)
        await cloud.track(trait: .period, level: .medium)
        
        let analysis = await cloud.analysis { _ in .firstQuarter }
        
        XCTAssertTrue(analysis[.sleep]?.isEmpty ?? false)
        XCTAssertNil(analysis[.period])
    }
}
