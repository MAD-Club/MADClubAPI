@_exported import Vapor

extension Droplet {
	public func setup() throws {
		// MARK: Home Route
		let homeController = HomeController()
		
		
		// MARK: User Routes
		let users = UserController()
		let userRoutes = grouped("users")
		users.addRoutes(userRoutes)
	}
}
