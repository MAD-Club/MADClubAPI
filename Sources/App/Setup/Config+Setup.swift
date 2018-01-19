import FluentProvider
import PostgreSQLProvider
import LeafProvider
import SendGridProvider

extension Config {
  public func setup() throws {
    // allow fuzzy conversions for these types
    // (add your own types here)
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    
    try setupProviders()
    try setupPreparations()
    addConfigurables()
  }
  
  /// Configure providers
  private func setupProviders() throws {
    try addProvider(FluentProvider.Provider.self)
    try addProvider(PostgreSQLProvider.Provider.self)
    try addProvider(LeafProvider.Provider.self)
    try addProvider(SendGridProvider.Provider.self)
  }
  
  private func addConfigurables() {
    addConfigurable(command: SeedCommand.init, name: "seed")
  }
  
  /// Add all models that should have their
  /// schemas prepared before the app boots
  private func setupPreparations() throws {
    preparations.append(EventType.self)
    // no migrations, just regular here
    preparations.append(Event.self)
    preparations.append(Asset.self)
    preparations.append(Pivot<Event, Asset>.self)
    preparations.append(User.self)
  }
}
