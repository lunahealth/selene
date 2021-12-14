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
            let angle = atan2(cos(sun.latitude)
                              * sin(sun.longitude - moon.latitude),
                              sin(sun.latitude)
                              * cos(moon.longitude)
                              - cos(sun.latitude)
                              * sin(moon.longitude)
                              * cos(sun.longitude - moon.latitude))
            self.init(inclination: inclination, angle: angle)
            
            
            
            /*
            
             let phase = 0.5 + ((0.5 * inclination) * (angle < 0 ? -1 : 1) / .pi)
             
             func phase(_ phase: Double) -> Phase {
                 if phase > 0.02 {
                     if phase < 0.249 {
                         return .waxingCrescent
                     } else if phase < 0.253 {
                         return .firstQuarter
                     } else if phase < 0.481 {
                         return .waxingGibbous
                     } else if phase < 0.52 {
                         return .full
                     } else if phase < 0.749 {
                         return .waningGibbous
                     } else if phase < 0.753 {
                         return .lastQuarter
                     } else if phase < 0.981 {
                         return .waningCrescent
                     }
                 }
                 return .new
             }
             
             private func inclination(_ phi: Double, _ moonDistanceKm: Double) -> Double {
                 atan2(sunDistanceKm * sin(phi), moonDistanceKm - sunDistanceKm * cos(phi))
             }
             
             private func angle(_ sunCoords: (Double, Double), _ moonCoords: (Double, Double, Double)) -> Double {
                 atan2(cos(sunCoords.0) * sin(sunCoords.1 - moonCoords.0),
                       sin(sunCoords.0) * cos(moonCoords.1) - cos(sunCoords.0) * sin(moonCoords.1) * cos(sunCoords.1 - moonCoords.0))
             }
             */
        }
        
        init(inclination: Double, angle: Double) {
            self = .waxingCrecent
        }
    }
}
