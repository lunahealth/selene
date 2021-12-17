import Foundation

private let Mean0 = 134.963
private let Mean1 = 13.064993
private let Distance0 = 93.272
private let Distance1 = 13.229350
private let EclipticalLongitude0 = 218.316
private let EclipticalLongitude1 = 13.176396
private let Latitude0 = 5.128
private let Longitude0 = 6.289
private let Km0 = 385001.0
private let Km1 = 20905.0

public struct Moon: Equatable {
    public let phase: Phase
    private let fraction: Double
    private let angle: Double
    private let azimuth: Double
    private let altitude: Double
    
    init(julianDay: Double, sun: Sun, location: Coords) {
        let meanAnomaly = (Mean0 + Mean1 * julianDay).toRadians
        let meanDistance = (Distance0 + Distance1 * julianDay).toRadians
        let eclipticalLongitude = (EclipticalLongitude0 + EclipticalLongitude1 * julianDay).toRadians
        let distanceKm = Km0 - (Km1 * cos(meanAnomaly))
        let coords = Earth.equatorial(coords: .init(latitude: (Latitude0 * sin(meanDistance)).toRadians,
                                                    longitude: (Longitude0 * sin(meanAnomaly)).toRadians + eclipticalLongitude))
            .inverse
        let latitude = acos(sin(sun.coords.latitude)
                            * sin(coords.longitude)
                            + cos(sun.coords.latitude)
                            * cos(coords.longitude)
                            * cos(sun.coords.longitude - coords.latitude))
        let inclination = atan2(Sun.DistanceKm * sin(latitude), distanceKm - Sun.DistanceKm * cos(latitude))
        let apparentAngle = atan2(cos(sun.coords.latitude)
                                  * sin(sun.coords.longitude - coords.latitude),
                                  sin(sun.coords.latitude)
                                  * cos(coords.longitude)
                                  - cos(sun.coords.latitude)
                                  * sin(coords.longitude)
                                  * cos(sun.coords.longitude - coords.latitude))
        
        let h = Earth.sidereal(julianDay: julianDay) - location.longitude - coords.latitude
        let parallacticAngle = atan2(sin(h),
                                     tan(location.latitude)
                                     * cos(coords.longitude)
                                     - sin(coords.longitude)
                                     * cos(h))
        phase = .init(inclination: inclination, angle: apparentAngle)
        fraction =  (1 + cos(inclination)) / 2
        altitude = Earth.astroRefraction(apparentAltitude: asin(
            sin(location.latitude)
            * sin(coords.longitude)
            + cos(location.latitude)
            * cos(coords.longitude)
            * cos(h)))
        angle = apparentAngle - parallacticAngle
        azimuth = atan2(sin(h),
                        cos(h)
                        * sin(location.latitude)
                        - tan(coords.longitude)
                        * cos(location.latitude))
    }
    
    init() {
        self.phase = .new
        self.fraction = 0
        self.angle = 0
        self.azimuth = 0
        self.altitude = 0
    }
}
