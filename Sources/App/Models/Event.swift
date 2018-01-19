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
  // MARK: Properties
  public var title: String
  public var content: String
  public var eventTypeId: Identifier
  
//  public var type: String
  
  public let storage: Storage = Storage()

  /**
    Creates an Event object, with title and content properties as the 'News' cast.
 
    - parameters:
      - eventTypeId: The Type of the event, in an id format
      - title: The title of the event
      - content: The content of the event
  **/
  public init(eventTypeId: Identifier, title: String, content: String) {
    self.eventTypeId = eventTypeId
    self.title = title
    self.content = content
  }
  
  public init(row: Row) throws {
    eventTypeId = try row.get("eventTypeId")
    title = try row.get("title")
    content = try row.get("content")
  }
  
  public func makeRow() throws -> Row {
    var row = Row()
    try row.set("eventTypeId", eventTypeId)
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
  
  public var eventType: Parent<Event, EventType> {
    return parent(id: eventTypeId)
  }
}

//MARK: Preparation - Setting up Database
extension Event: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { event in
      event.id()
      event.parent(EventType.self, foreignIdKey: "eventTypeId")
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
    try json.set("type", eventType.get()?.type)
    try json.set("galleries", galleries.all().makeJSON())
    try json.set("title", title)
    try json.set("content", content)
    // we can show the createdAt/UpdatedAt because of the Timestampable protocol
    try json.set("updatedAt", updatedAt)
    try json.set("createdAt", createdAt)
    return json
  }
}
