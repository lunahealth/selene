import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func update(traits: [Settings.Option]) async {
        guard traits != model.settings.traits else { return }
        model.settings = .init(traits: traits)
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
}
