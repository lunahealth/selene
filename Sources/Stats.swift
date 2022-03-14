public struct Stats: Equatable {    
    public let level: Level
    public let percent: Double
    
    public init(level: Level, percent: Double) {
        self.level = level
        self.percent = percent
    }
}
