import Foundation
import Archivable
import CoreLocation

private let flatRate = 100.0

public struct Coords: Storable, Hashable {
    public var data: Data {
        .init()
        .adding(Int16(latitude * flatRate))
        .adding(Int16(longitude * flatRate))
    }
    
    public let latitude: Double
    public let longitude: Double
    
    var radians: Self {
        .init(latitude: latitude.toRadians, longitude: -longitude.toRadians)
    }
    
    var flatten: Self {
        .init(latitude: round(latitude * flatRate) / flatRate, longitude: round(longitude * flatRate) / flatRate)
    }
    
    var inverse: Self {
        .init(latitude: longitude, longitude: latitude)
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    public init(data: inout Data) {
        latitude = .init(data.number() as Int16) / flatRate
        longitude = .init(data.number() as Int16) / flatRate
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
