//
//  User.swift
//  App
//
//  Created by Johnny Nguyen on 2017-10-04.
//

import Vapor
import BCrypt
import FluentProvider

public final class User: Model, Timestampable {
  //MARK: Properties
  public var name: String
  public var email: String
  public var role: String
  public var password: String
  public var profileURL: String = ""
  public var admin: Bool = false
  
	public var storage: Storage = Storage()
	
  /**
   Creates a `User` object, used for authenticating specific purposes
   
   - parameters:
     - name: The name of the user (full-name)
     - email: The email used for login
     - role: The role of the user
     - password: Password to login
     - admin: boolean value to check for specific access
  **/
  public init(name: String, email: String, role: String, password: String, admin: Bool = false) throws {
    self.name = name
    self.email = email
    self.role = role
    self.password = try Hash.make(message: password).makeString()
    self.admin = admin
  }
  
	public init(row: Row) throws {
    name = try row.get("name")
    email = try row.get("email")
    role = try row.get("role")
    password = try row.get("password")
    profileURL = try row.get("profileURL")
    admin = try row.get("admin")
	}
	
	public func makeRow() throws -> Row {
		var row = Row()
    try row.set("name", name)
    try row.set("email", email)
    try row.set("role", role)
    try row.set("password", password)
    try row.set("profileURL", profileURL)
    try row.set("admin", admin)
		return row
	}
}

//MARK: Preparation
extension User: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { user in
      user.id()
      user.string("name")
      user.string("email")
      user.string("role")
      user.string("password")
      user.string("profileURL", default: "")
      user.bool("admin", default: false)
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

//MARK: JSONRepresentable
extension User: JSONRepresentable {
  public func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("name", name)
    try json.set("email", email)
    try json.set("role", role)
    try json.set("admin", admin)
    try json.set("profileURL", profileURL)
    try json.set("createdAt", createdAt)
    try json.set("updatedAt", updatedAt)
    return json
  }
}
