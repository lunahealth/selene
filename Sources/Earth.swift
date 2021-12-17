import Foundation

private let Mean0 = 357.5291
private let Mean1 = 0.98560028
private let Center1 = 1.9148
private let Center2 = 0.02
private let Center3 = 0.0003
private let Perihelion = 102.9373.toRadians
private let Sidereal0 = 280.16
private let Sidereal1 = 360.9856235
private let Refraction0 = 0.0002967
private let Refraction1 = 0.00312536
private let Refraction2 = 0.08901179
private let Obliquity = 23.4393.toRadians

struct Earth {
    static func equatorial(coords: Coords) -> Coords {
        .init(latitude: asin(sin(coords.latitude)
                             * cos(Obliquity)
                             + cos(coords.latitude)
                             * sin(Obliquity)
                             * sin(coords.longitude)),
              longitude: atan2(sin(coords.longitude)
                               * cos(Obliquity)
                               - tan(coords.latitude)
                               * sin(Obliquity),
                               cos(coords.longitude)))
    }
    
    static func sun(julianDay: Double) -> Coords {
        let meanAnomaly = (Mean0 + Mean1 * julianDay).toRadians
        let equationOfCenter = (Center1 * sin(meanAnomaly)
                                + Center2 * sin(2 * meanAnomaly)
                                + Center3 * sin(3 * meanAnomaly)).toRadians
        let eclipticalLongitude = meanAnomaly + equationOfCenter + Perihelion + .pi
        return equatorial(coords: .init(latitude: 0, longitude: eclipticalLongitude))
    }
    
    static func sidereal(julianDay: Double) -> Double {
        (Sidereal0 + Sidereal1 * julianDay).toRadians
    }
    
    static func astroRefraction(apparentAltitude: Double) -> Double {
        let altitude = apparentAltitude >= 0 ? apparentAltitude : 0
        return apparentAltitude + (Refraction0 / tan(altitude + Refraction1 / (altitude + Refraction2)))
    }
}
