import Foundation

struct Sun {
    private let coords: Coords
    private let meanAnomaly: Double
    private let equationOfCenter: Double
    private let eclipticalLongitude: Double
    
    init(julianDay: Double) {
        meanAnomaly = (Earth.Mean0 + Earth.Mean1 * julianDay).toRadians
        equationOfCenter = (Earth.Center1 * sin(meanAnomaly)
                            + Earth.Center2 * sin(2 * meanAnomaly)
                            + Earth.Center3 * sin(3 * meanAnomaly)).toRadians
        eclipticalLongitude = meanAnomaly + equationOfCenter + Earth.Perihelion + .pi
        coords = .init(latitude: 0, longitude: eclipticalLongitude).equatorial
    }
}
