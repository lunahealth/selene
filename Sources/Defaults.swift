import Foundation

public enum Defaults: String {
    case
    rated,
    created,
    premium,
    location,
    coords,
    since,
    trait,
    haptics

    public static var action: Action {
        if let created = wasCreated {
            let days = Calendar.global.dateComponents([.day], from: created, to: .init()).day!
            if !hasRated && days > 6 {
                hasRated = true
                return .rate
            } else if hasRated && !isPremium && days > 7 {
                return .froob
            }
        } else {
            wasCreated = .init()
        }
        return .none
    }
    
    public static var isPremium: Bool {
        get { self[.premium] as? Bool ?? false }
        set { self[.premium] = newValue }
    }
    
    public static var hasRated: Bool {
        get { self[.rated] as? Bool ?? false }
        set { self[.rated] = newValue }
    }
    
    public static var hasLocated: Bool {
        get { self[.location] as? Bool ?? false }
        set { self[.location] = newValue }
    }
    
    public static var enableHaptics: Bool {
        get { self[.haptics] as? Bool ?? true }
        set { self[.haptics] = newValue }
    }
    
    public static var currentSince: Analysing {
        get { self[.since].flatMap { $0 as? UInt8 }.flatMap(Analysing.init(rawValue:)) ?? .all }
        set { self[.since] = newValue.rawValue }
    }
    
    public static var currentTrait: Trait? {
        get { self[.trait].flatMap { $0 as? UInt8 }.flatMap(Trait.init(rawValue:)) }
        set { self[.trait] = newValue?.rawValue }
    }
    
    public static var coordinates: Coords {
        get {
            share.data(forKey: Self.coords.rawValue)?.prototype()
            ?? .init(latitude: 52.522399, longitude: 13.413027)
        }
        set {
            share.setValue(newValue.data, forKey: Self.coords.rawValue)
        }
    }
    
    static var wasCreated: Date? {
        get { self[.created] as? Date }
        set { self[.created] = newValue }
    }
    
    private static let share = UserDefaults(suiteName: "group.moonhealth.share")!
    
    private static subscript(_ key: Self) -> Any? {
        get { UserDefaults.standard.object(forKey: key.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
}
