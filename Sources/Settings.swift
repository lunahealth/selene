import Foundation
import Archivable

public struct Settings: Storable {
    public let traits: Set<Trait>
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: traits.map(\.rawValue))
    }
    
    public init(data: inout Data) {
        traits = .init(data.collection(size: UInt8.self).compactMap(Trait.init(rawValue:)))
    }
    
    init() {
        self.init(traits: [])
    }
    
    private init(traits: Set<Trait>) {
        self.traits = traits
    }
    
    func removing(trait: Trait) -> Self {
        .init(traits: traits.removing(trait))
    }
    
    func adding(trait: Trait) -> Self {
        .init(traits: traits.inserting(trait))
    }
}
