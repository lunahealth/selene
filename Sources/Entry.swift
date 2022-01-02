import Foundation
import Archivable

public struct Entry: Storable, Hashable {
    public let trait: Trait
    public let value: UInt8
    
    public var data: Data {
        .init()
        .adding(trait.rawValue)
        .adding(value)
    }
    
    public init(trait: Trait, value: Double) {
        self.trait = trait
        self.value = value < 0
            ? 0
            : value > 100
                ? 100
                : .init(round(value))
    }
    
    public init(data: inout Data) {
        trait = .init(rawValue: data.number())!
        value = data.number()
    }
    
    public func hash(into: inout Hasher) {
        into.combine(trait)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.trait == rhs.trait
    }
}
