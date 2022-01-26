import Foundation
import Archivable

public struct Journal: Storable, Hashable {
    public let traits: [Trait : Level]
    let datestamp: Datestamp
    
    public var data: Data {
        .init()
        .adding(datestamp)
        .adding(UInt8(traits.count))
        .adding(traits.flatMap {
            Data()
                .adding($0.key.rawValue)
                .adding($0.value.rawValue)
        })
    }
    
    public init(data: inout Data) {
        datestamp = .init(data: &data)
        traits = (0 ..< .init(data.number() as UInt8))
            .reduce(into: [:]) { result, _ in
                result[.init(rawValue: data.number())!] = .init(rawValue: data.number())!
            }
    }
    
    init(date: Date) {
        self.init(datestamp: .init(date: date), traits: [:])
    }
    
    private init(datestamp: Datestamp, traits: [Trait : Level]) {
        self.datestamp = datestamp
        self.traits = traits
    }
    
    func with(trait: Trait, level: Level) -> Self {
        var traits = traits
        traits[trait] = level
        return .init(datestamp: datestamp, traits: traits)
    }
    
    func removing(trait: Trait) -> Self {
        var traits = traits
        traits.removeValue(forKey: trait)
        return .init(datestamp: datestamp, traits: traits)
    }
}
