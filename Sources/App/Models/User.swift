//
//  User.swift
//  App
//
//  Created by Johnny Nguyen on 2017-10-04.
//

import Vapor
import FluentProvider

public final class User: Model {
	public var storage: Storage = Storage()
	
	public init(row: Row) throws {
	
	}
	
	public func makeRow() throws -> Row {
		var row = Row()
		return row
	}
}
