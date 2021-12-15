import Foundation

public struct Coords {
    public let latitude: Double // declination
    public let longitude: Double // right ascencion
    
    var radians: Self {
        .init(latitude: latitude.toRadians, longitude: -longitude.toRadians)
    }
}
