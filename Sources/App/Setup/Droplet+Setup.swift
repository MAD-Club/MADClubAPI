@_exported import Vapor

extension Droplet {
	public func setup() throws {
		// add our collection
		try self.collection(V1Collection.self)
	
		// later on, we'll probably need to set our routes to connect for the website
	}
}
