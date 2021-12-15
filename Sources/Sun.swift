struct Sun {
    static let DistanceKm = 149598000.0
    
    let coords: Coords
    
    init(julianDay: Double) {
        coords = Earth.sun(julianDay: julianDay)
    }
}
