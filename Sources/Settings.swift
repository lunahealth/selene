import Foundation
import Archivable

public struct Settings: Storable {
    public let traits: [Option]
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: traits)
    }
    
    public init(data: inout Data) {
        traits = data.collection(size: UInt8.self)
    }
    
    init() {
        self.init(traits: [])
    }
    
    init(traits: [Option]) {
        self.traits = traits
    }
}
