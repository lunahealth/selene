import Foundation

extension Observatory {
    public struct Input: Hashable {
        let date: Date
        let coords: Coords
        
        public init(date: Date, coords: Coords) {
            self.date = date
            self.coords = coords
        }
    }
}
