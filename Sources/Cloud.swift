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
    
    public func analysis(since: Analysing, phase: (Date) -> Moon.Phase) -> [Trait : [Moon.Phase : Level]] {
        var result: [Trait : [Moon.Phase : [Level : Int]]] = model
            .settings
            .traits
            .reduce(into: [:]) {
                $0[$1] = [:]
            }
        
        let since = since.date
        
        model
            .journal
            .filter {
                $0.date > since
            }
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
    
    public func stats(since: Analysing, trait: Trait) -> [Stats] {
        let since = since.date
        
        let values = model
            .journal
            .filter {
                $0.date > since
            }
            .sorted {
                $0.date < $1.date
            }
            .flatMap {
                $0
                    .traits
                    .filter {
                        $0.key == trait
                    }
                    .map(\.value)
            }
        
        return values
            .reduce(into: [Level : Double]()) {
                $0[$1, default: 0] += 1
            }
            .sorted { left, right in
                left.value == right.value
                ? left.key.rawValue > right.key.rawValue
                : left.value > right.value
            }
            .map {
                .init(level: $0.key, percent: $0.value / .init(values.count))
            }
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
