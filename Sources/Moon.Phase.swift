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
        
        init(fraction: Int, angle: Double) {
            switch fraction {
            case 0 ... 2:
                self = .new
            case 3 ... 47:
                self = angle < 0 ? .waxingCrescent : .waningCrescent
            case 48 ... 52:
                self = angle < 0 ? .firstQuarter : .lastQuarter
            case 53 ... 97:
                self = angle < 0 ? .waxingGibbous : .waningGibbous
            default:
                self = .full
            }
        }
    }
}
