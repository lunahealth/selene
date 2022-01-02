import Foundation
import Archivable

public struct Journal: Storable {
    public let traits: [Trait : UInt8]
    
    public var data: Data {
        .init()
        .adding(UInt8(traits.count))
        .adding(traits.flatMap {
            Data()
                .adding($0.key.rawValue)
                .adding($0.value)
        })
    }
    
    public init(data: inout Data) {
        traits = (0 ..< .init(data.number() as UInt8))
            .reduce(into: [:]) { result, _ in
                result[.init(rawValue: data.number())!] = data.number()
            }
    }
    
    init() {
        self.init(traits: [:])
    }
    
    private init(traits: [Trait : UInt8]) {
        self.traits = traits
    }
    
    public func with(trait: Trait, value: Double) -> Self {
        var traits = traits
        traits[trait] = value < 0
            ? 0
            : value > 100
                ? 100
                : .init(round(value))
        return .init(traits: traits)
    }
}
