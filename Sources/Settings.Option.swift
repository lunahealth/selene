import Foundation
import Archivable

extension Settings {
    public struct Option: Storable {
        public var active: Bool
        public let trait: Trait
        
        public var data: Data {
            .init()
            .adding(trait.rawValue)
            .adding(active)
        }
        
        public init(data: inout Data) {
            trait = .init(rawValue: data.number())!
            active = data.bool()
        }
        
        public init(trait: Trait, active: Bool) {
            self.trait = trait
            self.active = active
        }
    }
}
