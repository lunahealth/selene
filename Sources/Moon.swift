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
private let EarthToSunKm = 149598000.0

public struct Moon: Equatable {
    public static let new = Self()
    
    public let phase: Phase
    public let fraction: Int
    public let angle: Double
    let inclination: Double
    let parallacticAngle: Double
    
    init(julianDay: Double, sun: Coords, location: Coords) {
        let meanAnomaly = (Mean0 + Mean1 * julianDay).toRadians
        let meanDistance = (Distance0 + Distance1 * julianDay).toRadians
        let eclipticalLongitude = (EclipticalLongitude0 + EclipticalLongitude1 * julianDay).toRadians
        let distanceKm = Km0 - (Km1 * cos(meanAnomaly))
        let coords = Earth.equatorial(
            coords: .init(latitude: (Latitude0 * sin(meanDistance)).toRadians,
                          longitude: (Longitude0 * sin(meanAnomaly)).toRadians + eclipticalLongitude)).inverse
        let latitude = acos(sin(sun.latitude)
                            * sin(coords.longitude)
                            + cos(sun.latitude)
                            * cos(coords.longitude)
                            * cos(sun.longitude - coords.latitude))
        let apparentAngle = atan2(cos(sun.latitude)
                                  * sin(sun.longitude - coords.latitude),
                                  sin(sun.latitude)
                                  * cos(coords.longitude)
                                  - cos(sun.latitude)
                                  * sin(coords.longitude)
                                  * cos(sun.longitude - coords.latitude))
        
        let h = Earth.sidereal(julianDay: julianDay) - location.longitude - coords.latitude
        
        inclination = atan2(EarthToSunKm * sin(latitude), distanceKm - EarthToSunKm * cos(latitude))
        parallacticAngle = atan2(sin(h),
                                     tan(location.latitude)
                                     * cos(coords.longitude)
                                     - sin(coords.longitude)
                                     * cos(h))
        phase = .init(inclination: inclination, angle: apparentAngle)
        fraction = .init(round((1 + cos(inclination)) / 2 * 100))
        angle = apparentAngle - parallacticAngle
    }
    
    init(phase: Phase = .new, fraction: Int = 0, angle: Double = 0, inclination: Double = 0, parallacticAngle: Double = 0) {
        self.phase = phase
        self.fraction = fraction
        self.angle = angle
        self.inclination = inclination
        self.parallacticAngle = parallacticAngle
    }
}
