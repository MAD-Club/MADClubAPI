//
//  HomeController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-11-06.
//

import Vapor
import HTTP

public final class HomeController {
	// we only set this as to indicate that this will be called no matter what
	private var drop: Droplet!

	public func addRoutes(_ drop: Droplet) {
		self.drop = drop
		// get the home index here to test
		drop.get(handler: index)
	}
	
	/**
		Our home index. We won't add this into addRoutes, because we want to set this as the index page.
	*/
	public func index(request: Request) throws -> ResponseRepresentable {
		return try drop.view.make("index")
	}
}
