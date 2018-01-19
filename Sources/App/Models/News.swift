//
//  Event.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Foundation
import FluentProvider
import Vapor

public final class News: Model, Timestampable {
  // MARK: Properties
  public var title: String
  public var content: String
  
//  public var type: String
  
  public let storage: Storage = Storage()

  /**
    Creates an Event object, with title and content properties as the 'News' cast.
 
    - parameters:
      - title: The title of the event
      - content: The content of the event
  **/
  public init(title: String, content: String) {
    self.title = title
    self.content = content
  }
  
  public init(row: Row) throws {
    title = try row.get("title")
    content = try row.get("content")
  }
  
  public func makeRow() throws -> Row {
    var row = Row()
    try row.set("title", title)
    try row.set("content", content)
    return row
  }
}

//MARK: Preparation - Setting up Database
extension News: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { news in
      news.id()
      news.string("title")
      news.custom("content", type: "TEXT")
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

//MARK: JSON
extension News: JSONRepresentable {
  public func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("title", title)
    try json.set("content", content)
    // we can show the createdAt/UpdatedAt because of the Timestampable protocol
    try json.set("updatedAt", updatedAt)
    try json.set("createdAt", createdAt)
    return json
  }
}
