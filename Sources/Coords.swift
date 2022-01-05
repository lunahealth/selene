import Foundation
import Archivable
import CoreLocation

private let flatRate = 10.0

public struct Coords: Storable, Hashable {
    public var data: Data {
        .init()
        .adding(UInt16(latitude * flatRate))
        .adding(UInt16(longitude * flatRate))
    }
    
    public let latitude: Double
    public let longitude: Double
    
    var radians: Self {
        .init(latitude: latitude.toRadians, longitude: -longitude.toRadians)
    }
    
    var flatten: Self {
        .init(latitude: floor(latitude * flatRate) / flatRate, longitude: floor(longitude * flatRate) / flatRate)
    }
    
    var inverse: Self {
        .init(latitude: longitude, longitude: latitude)
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    public init(data: inout Data) {
        latitude = .init(data.number() as UInt16) / flatRate
        longitude = .init(data.number() as UInt16) / flatRate
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
