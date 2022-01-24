import XCTest
@testable import Archivable
@testable import Selene

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testTraits() async {
        var model = await cloud.model
        XCTAssertTrue(model.settings.traits.isEmpty)
        
        await cloud.toggle(trait: .period, mode: true)
        
        model = await cloud.model
        XCTAssertEqual(.period, model.settings.traits.first)
        
        await cloud.toggle(trait: .period, mode: false)
        
        model = await cloud.model
        XCTAssertTrue(model.settings.traits.isEmpty)
    }
    
    func testTrack() async {
        let day = UInt32(123456)
        
        var model = await cloud.model
        XCTAssertTrue(model.journal.isEmpty)
        
        await cloud.track(journal: day, trait: .period, level: .medium)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(.period, model.journal[day]?.traits.first?.key)
        XCTAssertEqual(.medium, model.journal[day]?.traits.first?.value)
        
        await cloud.track(journal: day, trait: .period, level: .low)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(1, model.journal[day]?.traits.count)
        XCTAssertEqual(.period, model.journal[day]?.traits.first?.key)
        XCTAssertEqual(.low, model.journal[day]?.traits.first?.value)
        
        await cloud.track(journal: day, trait: .sleep, level: .top)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(2, model.journal[day]?.traits.count)
        
        await cloud.remove(journal: day, trait: .period)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(1, model.journal[day]?.traits.count)
        XCTAssertEqual(.sleep, model.journal[day]?.traits.first?.key)
        XCTAssertEqual(.top, model.journal[day]?.traits.first?.value)
        
        await cloud.remove(journal: day, trait: .sleep)
        model = await cloud.model
        XCTAssertTrue(model.journal.isEmpty)
    }
    
    func testLocation() async {
        await cloud.coords(latitude: 3.4560, longitude: 1.2345)
        let coords = await cloud.model.coords
        XCTAssertEqual(3.4560, coords.latitude)
        XCTAssertEqual(1.2345, coords.longitude)
    }
}
