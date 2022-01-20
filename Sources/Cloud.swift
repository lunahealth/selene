import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func toggle(trait: Trait, mode: Bool) async {
        if mode {
            model.settings = model.settings.adding(trait: trait)
        } else {
            model.settings = model.settings.removing(trait: trait)
        }
        await stream()
    }
    
    public func track(day: Day, journal: Journal) async {
        guard model.journal[day.journal] != journal else { return }
        if journal.traits.isEmpty {
            model.journal.removeValue(forKey: day.journal)
        } else {
            model.journal[day.journal] = journal
        }
        await stream()
    }
    
    public func coords(latitude: Double, longitude: Double) async {
        guard model.coords.latitude != latitude && model.coords.longitude != longitude else { return }
        model.coords = .init(latitude: latitude, longitude: longitude)
        await stream()
    }
}
