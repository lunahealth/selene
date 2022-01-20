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
        
        await cloud.update(traits: [.init(trait: .period, active: true)])
        
        model = await cloud.model
        XCTAssertEqual(.period, model.settings.traits.first?.id)
    }
    
    func testTrack() async {
        var journal = Journal()
        let day = Day(id: .now, moon: .init(), journal: 123456)
        
        var model = await cloud.model
        XCTAssertTrue(model.journal.isEmpty)
        
        await cloud.track(day: day, journal: journal)
        model = await cloud.model
        XCTAssertTrue(model.journal.isEmpty)
        
        journal = journal.with(trait: .period, value: 5)
        await cloud.track(day: day, journal: journal)
        model = await cloud.model
        XCTAssertEqual(1, model.journal.count)
        XCTAssertEqual(.period, model.journal[day.journal]?.traits.first?.key)
        XCTAssertEqual(5, model.journal[day.journal]?.traits.first?.value)
        
        journal = .init()
        await cloud.track(day: day, journal: journal)
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
