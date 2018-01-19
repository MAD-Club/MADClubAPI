//
//  Event.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-18.
//

import Foundation
import Vapor
import FluentProvider

public final class Event: Model, Timestampable {
  // MARK: Properties
  public var title: String
  public var description: String
  public var startDate: Date
  public var endDate: Date
  
  public let storage: Storage = Storage()
  
  public init(title: String, description: String, startDate: Date, endDate: Date) {
    self.title = title
    self.description = description
    self.startDate = startDate
    self.endDate = endDate
  }
  
  public init(row: Row) throws {
    title = try row.get("title")
    description = try row.get("description")
    startDate = try row.get("startDate")
    endDate = try row.get("endDate")
  }
  
  public func makeRow() throws -> Row {
    var row = Row()
    try row.set("title", title)
    try row.set("description", description)
    return row
  }
}

//MARK: Event
extension Event {
  public var galleries: Siblings<Event, Asset, Pivot<Event, Asset>> {
    return siblings()
  }
}

extension Event: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { event in
      event.id()
      event.string("title")
      event.string("description")
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension Event: JSONRepresentable {
  public func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("title", title)
    try json.set("description", description)
    try json.set("startDate", startDate)
    try json.set("endDate", endDate)
    return json
  }
}
