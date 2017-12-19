@_exported import Vapor
import LeafProvider

extension Droplet {
	public func setup() throws {
		try setupRoutes()
    prepareStems()
	}
  
  // prepares the stems for us
  private func prepareStems() {
    if let leaf = view as? LeafRenderer {
      leaf.stem.register(DateFormat())
    }
  }
}
