//
//  EventController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Vapor
import HTTP

public final class EventController {
  
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  /**
    An API Call for JSON
  **/
  public func all(_ req: Request) throws -> ResponseRepresentable {
    return try Event.all().makeJSON()
  }
  
  /**
   Returns the page on the web
  **/
  public func index(_ req: Request) throws -> ResponseRepresentable {
    let events = try Event.all()
    
    return try view.make("events", ["events": events])
  }
}
