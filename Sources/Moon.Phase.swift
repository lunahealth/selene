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
            case 0 ... 1:
                self = .new
            case 2 ... 48:
                self = angle < 0 ? .waxingCrescent : .waningCrescent
            case 49 ... 51:
                self = angle < 0 ? .firstQuarter : .lastQuarter
            case 52 ... 98:
                self = angle < 0 ? .waxingGibbous : .waningGibbous
            default:
                self = .full
            }
        }
    }
}
