import Foundation

public struct Coords {
    public let latitude: Double // declination
    public let longitude: Double // right ascencion
    
    var equatorial: Self {
        .init(latitude: declination, longitude: rightAscension)
    }
    
    var radians: Self {
        .init(latitude: latitude.toRadians, longitude: -longitude.toRadians)
    }
    
    private var declination: Double {
        asin(sin(latitude) * cos(Earth.Obliquity) + cos(latitude) * sin(Earth.Obliquity) * sin(longitude))
    }
    
    private var rightAscension: Double {
        atan2(sin(longitude) * cos(Earth.Obliquity) - tan(latitude) * sin(Earth.Obliquity), cos(longitude))
    }
}
