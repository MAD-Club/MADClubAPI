@_exported import Vapor
import LeafProvider
import MarkdownProvider

public var drop: Droplet?

extension Droplet {
	public func setup() throws {
		try setupRoutes()
    prepareStems()
    drop = self
	}
  
  // prepares the stems for us
  private func prepareStems() {
    if let leaf = view as? LeafRenderer {
      leaf.stem.register(DateFormat())
      leaf.stem.register(IndexObject())
      leaf.stem.register(Markdown())
    }
  }
}
