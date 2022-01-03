import Foundation
import Archivable

extension Settings {
    public struct Option: Storable, Identifiable, Equatable {
        public var active: Bool
        public let id: Trait
        
        public var data: Data {
            .init()
            .adding(id.rawValue)
            .adding(active)
        }
        
        public init(data: inout Data) {
            id = .init(rawValue: data.number())!
            active = data.bool()
        }
        
        public init(trait: Trait, active: Bool) {
            self.id = trait
            self.active = active
        }
    }
}
