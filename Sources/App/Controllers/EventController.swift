//
//  EventController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Vapor
import HTTP
import Foundation

public final class EventController {
  
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  /**
    An API Call for JSON
  **/
  public func all(_ req: Request) throws -> ResponseRepresentable {
    return try Event.makeQuery()
      .filter("eventTypeId", EventType.Category.event.id())
      .all()
      .makeJSON()
  }
  
  /**
   Returns the page on the web
  **/
  public func index(_ req: Request) throws -> ResponseRepresentable {
    let events = try Event.makeQuery().filter("eventTypeId", EventType.Category.event.id()).all()
    
    // we're checking for a session in this case
    var results = ["events": try events.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("events", results)
  }
}
