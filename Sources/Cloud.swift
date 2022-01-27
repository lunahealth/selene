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
    
    public func remove(trait: Trait) async {
        let journal = model[.now] ?? .init(date: .now)
        await update(journal: journal.removing(trait: trait))
    }
    
    public func coords(latitude: Double, longitude: Double) async {
        guard model.coords.latitude != latitude && model.coords.longitude != longitude else { return }
        model.coords = .init(latitude: latitude, longitude: longitude)
        await stream()
    }
    
    private func update(journal: Journal) async {
        guard journal != model[.now] else { return }
        if journal.traits.isEmpty {
            model.remove(date: journal.date)
        } else {
            model.replace(item: journal)
        }
        await stream()
    }
}
