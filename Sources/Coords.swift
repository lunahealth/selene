import Foundation
import CoreLocation

private let flatRate = 100.0

public struct Coords: Hashable {
    public let latitude: Double // declination
    public let longitude: Double // right ascencion
    
    var radians: Self {
        .init(latitude: latitude.toRadians, longitude: -longitude.toRadians)
    }
    
    var flatten: Self {
        .init(latitude: floor(latitude * flatRate) / flatRate, longitude: floor(longitude * flatRate) / flatRate)
    }
    
    public init(coordinate: CLLocationCoordinate2D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}
