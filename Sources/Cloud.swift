import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func toggle(trait: Trait, mode: Bool) async {
        if mode {
            guard !model.settings.traits.contains(trait) else { return }
            model.settings = model.settings.adding(trait: trait)
            await stream()
        } else {
            guard model.settings.traits.contains(trait) else { return }
            model.settings = model.settings.removing(trait: trait)
            await stream()
        }
    }
    
    public func track(trait: Trait, level: Level) async {
        let journal = model[.now] ?? .init(date: .now)
        await update(journal: journal.with(trait: trait, level: level))
    }
    
    public func delete() async {
        model.clear()
        await stream()
    }
    
    public func delete(trait: Trait) async {
        model.remove(trait: trait)
        await stream()
    }
    
    public func remove(trait: Trait) async {
        let journal = model[.now] ?? .init(date: .now)
        await update(journal: journal.removing(trait: trait))
    }
    
    public func analysis(phase: (Date) -> Moon.Phase) -> [Trait : [Moon.Phase : Level]] {
        var result: [Trait : [Moon.Phase : [Level : Int]]] = model
            .settings
            .traits
            .reduce(into: [:]) {
                $0[$1] = [:]
            }
        
        model
            .journal
            .forEach { journal in
                journal
                    .traits
                    .forEach { trait, level in
                        result[trait]?[phase(journal.date), default: [:]][level, default: 0] += 1
                    }
            }
        
        return result
            .reduce(into: [:]) { result, item in
                result[item.key] = item
                    .value
                    .reduce(into: [:]) { subresult, subitem in
                        subresult[subitem.key] = subitem
                            .value
                            .max { a, b in
                                a.value == b.value
                                    ? a.key.rawValue < b.key.rawValue
                                    : a.value < b.value
                            }!
                            .key
                    }
            }
    }
    
    public func coords(latitude: Double, longitude: Double) async {
        guard model.coords.latitude != latitude && model.coords.longitude != longitude else { return }
        model.coords = .init(latitude: latitude, longitude: longitude)
        await stream()
    }
    
    func update(journal: Journal) async {
        guard journal != model[journal.date] else { return }
        if journal.traits.isEmpty {
            model.remove(date: journal.date)
        } else {
            model.replace(item: journal)
        }
        await stream()
    }
}
