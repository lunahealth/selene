import Foundation

public struct Observatory {
    func moon(at: Date, on: Coords) async -> Moon {
        .init(phase: .waxingCrescent, fraction: 0, angle: 0, azimuth: 0, altitude: 0)
    }
}


/*
 func info(_ time: TimeInterval, _ latitude: Double, _ longitude: Double) -> Info {
         let _days = days(time)
         let _sunCoords = sunCoords(_days)
         let _moonCoords = moonCoords(_days)
         let _inclination = inclination(phi(_sunCoords, _moonCoords), _moonCoords.2)
         let _angle = angle(_sunCoords, _moonCoords)
         let _lw = radians * -longitude
         let _phi = radians * latitude
         let _h = siderealTime(_days, _lw) - _moonCoords.0
         let _altitude = altitude(_h, _phi, _moonCoords.1)
         let _parallacticeAngle = atan2(sin(_h), tan(_phi) * cos(_moonCoords.1) - sin(_moonCoords.1) * cos(_h))
         
         var info = Info()
         info.phase = phase(phase(_inclination, _angle))
         info.fraction = fraction(_inclination)
         info.angle = _angle - _parallacticeAngle
         info.azimuth = azimuth(_h, _phi, _moonCoords.1)
         info.altitude = _altitude + astroRefraction(_altitude)
         return info
     }
 */
