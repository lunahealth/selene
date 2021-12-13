import Foundation

extension Moon {
    public enum Phase {
        case
        new,
        waxingCrescent,
        firstQuarter,
        waxingGibbous,
        full,
        waningGibbous,
        lastQuarter,
        waningCrescent
        
        init(moon: Coords, sun: Coords, distanceKm: Double) {
            let latitude = acos(sin(sun.latitude)
                                * sin(moon.longitude)
                                + cos(sun.latitude)
                                * cos(moon.longitude)
                                * cos(sun.longitude - moon.latitude))
            let inclination = atan2(Sun.DistanceKm * sin(latitude), distanceKm - Sun.DistanceKm * cos(latitude))
            
            /*
             private func inclination(_ phi: Double, _ moonDistanceKm: Double) -> Double {
                 atan2(sunDistanceKm * sin(phi), moonDistanceKm - sunDistanceKm * cos(phi))
             }
             */
        }
    }
}
