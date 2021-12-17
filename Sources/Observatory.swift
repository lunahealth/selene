import Foundation

public final actor Observatory {
    private(set) var cache = [Input : Moon]()
    
    public init() { }
    
    public func moon(input: Input) async -> Moon {
        guard let cached = cache[input] else {
            return await Task
                .detached(priority: .utility) { [weak self] in
                    await self?.add(input: input) ?? .init()
                }
                .value
        }
        return cached
    }
    
    private func add(input: Input) -> Moon {
        let julianDay = input.date.julianDay
        let moon = Moon(julianDay: julianDay, sun: Earth.sun(julianDay: julianDay), location: input.coords.radians)
        cache[input] = moon
        return moon
    }
}
