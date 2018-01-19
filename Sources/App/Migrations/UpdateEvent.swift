//
//  UpdateEventTable.swift
//  web
//
//  Created by Johnny Nguyen on 2018-01-18.
//

import Vapor
import FluentProvider

public struct UpdateEvent: Preparation {
  // the "up" function for those who are into rails/laravel for migrations
  public static func prepare(_ database: Database) throws {
    // modify the contents
    try database.modify(Event.self) { event in
      event.parent(EventType.self, foreignIdKey: "eventTypeId")
    }
  }
  
  // the "down" function for those who are into rails/laravel when migrating
  public static func revert(_ database: Database) throws { }
}
