@_exported import Vapor

extension Droplet {
	public func setup() throws {
		// MARK: Home Route
		// first we want to use the home index route to add in, and then we'll use the addRoutes
		
		let home = HomeController()
		home.addRoutes(self)
		
		// MARK: User Routes
		let users = UserController()
		let userRoutes = grouped("users")
		users.addRoutes(userRoutes)
	}
}
