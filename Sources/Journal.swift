import Foundation
import Archivable

public struct Journal: Storable, Equatable {
    public let traits: [Trait : Level]
    
    public var data: Data {
        .init()
        .adding(UInt8(traits.count))
        .adding(traits.flatMap {
            Data()
                .adding($0.key.rawValue)
                .adding($0.value.rawValue)
        })
    }
    
    public init(data: inout Data) {
        traits = (0 ..< .init(data.number() as UInt8))
            .reduce(into: [:]) { result, _ in
                result[.init(rawValue: data.number())!] = .init(rawValue: data.number())!
            }
    }
    
    init() {
        self.init(traits: [:])
    }
    
    private init(traits: [Trait : Level]) {
        self.traits = traits
    }
    
    func with(trait: Trait, level: Level) -> Self {
        var traits = traits
        traits[trait] = level
        return .init(traits: traits)
    }
    
    func removing(trait: Trait) -> Self {
        var traits = traits
        traits.removeValue(forKey: trait)
        return .init(traits: traits)
    }
}
