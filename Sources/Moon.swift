import Foundation

public struct Moon {
    private static let Mean0 = 134.963
    private static let Mean1 = 13.064993
    private static let Distance0 = 93.272
    private static let Distance1 = 13.229350
    private static let EclipticalLongitude0 = 218.316
    private static let EclipticalLongitude1 = 13.176396
    private static let Latitude0 = 5.128
    private static let Longitude0 = 6.289
    private static let Km0 = 385001.0
    private static let Km1 = 20905.0
    
    private let coords: Coords
    private let meanAnomaly: Double
    private let meanDistance: Double
    private let eclipticalLongitude: Double
    private let distanceKm: Double
    
    init(julianDay: Double) {
        meanAnomaly = (Self.Mean0 + Self.Mean1 * julianDay).toRadians
        meanDistance = (Self.Distance0 + Self.Distance1 * julianDay).toRadians
        eclipticalLongitude = (Self.EclipticalLongitude0 + Self.EclipticalLongitude1 * julianDay).toRadians
        distanceKm = Self.Km0 - (Self.Km1 * cos(meanAnomaly))
        coords = .init(latitude: (Self.Latitude0 * sin(meanDistance)).toRadians,
                       longitude: (Self.Longitude0 * sin(meanAnomaly)).toRadians + eclipticalLongitude)
            .equatorial
    }
}
