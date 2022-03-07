import XCTest
@testable import Selene

final class DefaultsTests: XCTestCase {
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: Defaults.rated.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.created.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.premium.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.location.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.coords.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.since.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.trait.rawValue)
        UserDefaults(suiteName: "group.moonhealth.share")!.removeObject(forKey: Defaults.coords.rawValue)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: Defaults.rated.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.created.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.premium.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.location.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.coords.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.since.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.trait.rawValue)
        UserDefaults(suiteName: "group.moonhealth.share")!.removeObject(forKey: Defaults.coords.rawValue)
    }
    
    func testFirstTime() {
        XCTAssertNil(UserDefaults.standard.object(forKey: Defaults.created.rawValue))
        XCTAssertEqual(.none, Defaults.action)
        XCTAssertNotNil(UserDefaults.standard.object(forKey: Defaults.created.rawValue))
    }
    
    func testRate() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -6, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertEqual(.none, Defaults.action)
        XCTAssertFalse(Defaults.hasRated)
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -7, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertEqual(.rate, Defaults.action)
        XCTAssertTrue(Defaults.hasRated)
        XCTAssertEqual(.none, Defaults.action)
    }
    
    func testFroob() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -7, to: .now)!, forKey: Defaults.created.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.rated.rawValue)
        XCTAssertEqual(.none, Defaults.action)
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -8, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertEqual(.froob, Defaults.action)
        XCTAssertEqual(.froob, Defaults.action)
    }
    
    func testPremium() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -7, to: .now)!, forKey: Defaults.created.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.premium.rawValue)
        XCTAssertEqual(.rate, Defaults.action)
    }
    
    func testCompleted() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -10, to: .now)!, forKey: Defaults.created.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.premium.rawValue)
        UserDefaults.standard.setValue(true, forKey: Defaults.rated.rawValue)
        XCTAssertEqual(.none, Defaults.action)
    }
    
    func testCoordinates() {
        XCTAssertNil(Defaults.coordinates)
        Defaults.coordinates = .init(latitude: 1, longitude: 2)
        XCTAssertEqual(.init(latitude: 1, longitude: 2), Defaults.coordinates)
    }
    
    func testSince() {
        XCTAssertEqual(.all, Defaults.currentSince)
        Defaults.currentSince = .month
        XCTAssertEqual(.month, Defaults.currentSince)
    }
    
    func testTrait() {
        XCTAssertNil(Defaults.currentTrait)
        Defaults.currentTrait = .period
        XCTAssertEqual(.period, Defaults.currentTrait)
    }
}
