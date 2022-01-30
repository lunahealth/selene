extension Moon {
    public enum Phase: CaseIterable {
        case
        new,
        waxingCrescent,
        firstQuarter,
        waxingGibbous,
        full,
        waningGibbous,
        lastQuarter,
        waningCrescent
        
        init(inclination: Double, angle: Double) {
            switch 0.5 + (0.5 * inclination * (angle < 0 ? -1 : 1) / .pi) {
            case 0.021 ..< 0.249:
                self = .waxingCrescent
            case 0.249 ..< 0.253:
                self = .firstQuarter
            case 0.253 ..< 0.481:
                self = .waxingGibbous
            case 0.481 ..< 0.52:
                self = .full
            case 0.52 ..< 0.749:
                self = .waningGibbous
            case 0.749 ..< 0.753:
                self = .lastQuarter
            case 0.753 ..< 0.981:
                self = .waningCrescent
            default:
                self = .new
            }
        }
    }
}
