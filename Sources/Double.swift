extension Double {
    public static let pi2 = Self.pi * 2
    public static let pi_2 = Self.pi / 2
    
    var toRadians: Self {
        self * .pi / 180
    }
}
