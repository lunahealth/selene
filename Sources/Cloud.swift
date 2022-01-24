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
    
    public func track(journal: UInt32, trait: Trait, level: Level) async {
        await update(day: journal, journal: model
                        .journal[journal, default: .init()]
                        .with(trait: trait, level: level))
    }
    
    public func remove(journal: UInt32, trait: Trait) async {
        await update(day: journal, journal: model
                        .journal[journal, default: .init()]
                        .removing(trait: trait))
    }
    
    public func coords(latitude: Double, longitude: Double) async {
        guard model.coords.latitude != latitude && model.coords.longitude != longitude else { return }
        model.coords = .init(latitude: latitude, longitude: longitude)
        await stream()
    }
    
    private func update(day: UInt32, journal: Journal) async {
        guard journal != model.journal[day] else { return }
        if journal.traits.isEmpty {
            model.journal[day] = nil
        } else {
            model.journal[day] = journal
        }
        await stream()
    }
}
