//
//  Event.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Foundation
import FluentProvider
import Vapor

public final class Event: Model, Timestampable {
  //MARK: Properties
  public var title: String
  public var content: String
  
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

//MARK: Event
extension Event {
  public var galleries: Siblings<Event, Asset, Pivot<Event, Asset>> {
    return siblings()
  }
}

//MARK: Preparation - Setting up Database
extension Event: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { event in
      event.id()
      event.string("title")
      event.custom("content", type: "TEXT")
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

//MARK: JSON
extension Event: JSONRepresentable {
  public func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("galleries", galleries.all().makeJSON())
    try json.set("title", title)
    try json.set("content", content)
    // we can show the createdAt/UpdatedAt because of the Timestampable protocol
    try json.set("updatedAt", updatedAt)
    try json.set("createdAt", createdAt)
    return json
  }
}
