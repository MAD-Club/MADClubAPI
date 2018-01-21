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
  
  // MARK: API Calls
  
  /**
    An API Call for JSON
  **/
  public func all(_ req: Request) throws -> ResponseRepresentable {
    return try Event.makeQuery()
      .all()
      .makeJSON()
  }
  
  public func getEvent(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int else {
      throw Abort.badRequest
    }
    
    guard let event = try Event.find(id) else {
      throw Abort.notFound
    }
    
    return try event.makeJSON()
  }
  
  // MARK: Web Calls
  
  /**
   Returns the page on the web
  **/
  public func index(_ req: Request) throws -> ResponseRepresentable {
    let events = try Event.makeQuery().all()
    
    // we're checking for a session in this case
    var results = ["events": try events.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("events/index", results)
  }
  
  /**
    Returns the event based on that id
  */
  public func show(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let event = try Event.find(id) else {
      return try view.make("events/index")
    }
    
    var results = ["event": try event.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("events/show", results)
  }
  
  /**
    Returns the event view
  */
  public func createEventView(_ req: Request) throws -> ResponseRepresentable {
    return try view.make("events/create", req.getUser())
  }
  
  /**
    Attempts to create the event
  */
  public func createEvent(_ req: Request) throws -> ResponseRepresentable {
    guard
      let title = req.formURLEncoded?["title"]?.string,
      let description = req.formURLEncoded?["description"]?.string,
      let startDate = req.formURLEncoded?["startDate"]?.customDate,
      let endDate = req.formURLEncoded?["endDate"]?.customDate else {
        return try view.make("events/create", ["error": "Unfilled Information!"])
    }

    // checks and makes sure the dates are properly set
    guard startDate < endDate else {
      return try view.make("events/create", ["error": "Your initial date can't be greater than your end date!"])
    }

    let event = Event(title: title, description: description, startDate: startDate, endDate: endDate)
    try event.save()
    
    // assuming everything is fine, it'll revert to here
    return Response(redirect: "/events")
  }
}
