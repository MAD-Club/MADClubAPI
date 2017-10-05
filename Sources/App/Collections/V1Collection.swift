//
//  V1Collection.swift
//  App
//  Created by Johnny Nguyen on 2017-10-04.

import Vapor
import HTTP

public final class V1Collection: RouteCollection, EmptyInitializable {
	public init () { }
	
	public func build(_ builder: RouteBuilder) throws {
		let api = builder.grouped("api", "v1")
		
		// setup our controllers here
	}
}
