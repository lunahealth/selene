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
        var model = await cloud.model
        XCTAssertTrue(model.journal.isEmpty)
        
        await cloud.track(trait: .period, level: .medium)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(.period, model[.now]?.traits.first?.key)
        XCTAssertEqual(.medium, model[.now]?.traits.first?.value)
        
        await cloud.track(trait: .period, level: .low)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(1, model[.now]?.traits.count)
        XCTAssertEqual(.period, model[.now]?.traits.first?.key)
        XCTAssertEqual(.low, model[.now]?.traits.first?.value)
        
        await cloud.track(trait: .sleep, level: .top)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(2, model[.now]?.traits.count)
        
        await cloud.remove(trait: .period)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(1, model[.now]?.traits.count)
        XCTAssertEqual(.sleep, model[.now]?.traits.first?.key)
        XCTAssertEqual(.top, model[.now]?.traits.first?.value)
        
        await cloud.remove(trait: .sleep)
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
