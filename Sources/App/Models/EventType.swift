//
//  EventType.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-18.
//

import Foundation
import Vapor
import FluentProvider

public final class EventType: Model {
  // MARK: Properties
  public var type: String
  
  public let storage: Storage = Storage()
  
  public init(row: Row) throws {
    type = try row.get("type")
  }
  
  public func makeRow() throws -> Row {
    var row = Row()
    try row.set("type", type)
    return row
  }
}

extension EventType: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string("type")
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}
