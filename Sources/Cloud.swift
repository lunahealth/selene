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
    
    public func track(day: Day, trait: Trait, level: Level) async {
        await update(day: day, journal: model
                        .journal[day.journal, default: .init()]
                        .with(trait: trait, level: level))
    }
    
    public func remove(day: Day, trait: Trait) async {
        await update(day: day, journal: model
                        .journal[day.journal, default: .init()]
                        .removing(trait: trait))
    }
    
    public func coords(latitude: Double, longitude: Double) async {
        guard model.coords.latitude != latitude && model.coords.longitude != longitude else { return }
        model.coords = .init(latitude: latitude, longitude: longitude)
        await stream()
    }
    
    private func update(day: Day, journal: Journal) async {
        guard journal != model.journal[day.journal] else { return }
        if journal.traits.isEmpty {
            model.journal[day.journal] = nil
        } else {
            model.journal[day.journal] = journal
        }
        await stream()
    }
}
