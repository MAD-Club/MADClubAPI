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
    
    // if the query exists, we can attempt to delete
    // we'll do a dirty check if the user is an admin or not
    if let id = req.query?["id"]?.int, let event = try Event.find(id) {
      if try req.getUserData().admin {
        // before deleting the event, we want to check all the assets and attempt to delete that as well
        try event.galleries.all().forEach {
          try event.galleries.remove($0)
          try $0.delete()
        }
        
        try event.delete()
        return Response(redirect: "/events")
      }
    }
    
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
  
  /**
   Returns the edit event view page
  */
  public func editEventView(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let event = try Event.find(id) else {
      return Response(redirect: "/events")
    }
    
    var results = try ["event": event.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("events/edit", results)
  }
  
  /**
   Attempts to edit the event for us, unforunately this is a post due to HTML
  */
  public func editEvent(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let event = try Event.find(id) else {
      return Response(redirect: "/events")
    }
    
    // attempt to change contents here
    event.title = req.formURLEncoded?["title"]?.string ?? event.title
    event.description = req.formURLEncoded?["description"]?.string ?? event.description
    event.startDate = req.formURLEncoded?["startDate"]?.customDate ?? event.startDate
    event.endDate = req.formURLEncoded?["endDate"]?.customDate ?? event.endDate
    
    guard event.startDate < event.endDate else {
      return try view.make("events/edit", ["error": "Your start date is higher than your end date!", "event": event.makeJSON()])
    }
    
    try event.save()
    
    return Response(redirect: "/events/\(id)")
  }
  
  /**
   Post request to upload images to events
   */
  public func uploadImageForEvent(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let event = try Event.find(id) else {
      return Response(redirect: "/events")
    }
    
    guard let fileName = req.formData?["file"]?.filename, let file = req.formData?["file"]?.part.body else {
      return try view.make("events/upload", ["error": "No files selected for upload!"])
    }
    
    guard let config = drop?.config["kloudless"] else { throw Abort.serverError }

    let kloudless = try KloudlessService(config: config)

    let asset = try kloudless.uploadImage(fileName: fileName, file: file)
    
    // add the asset that was created here
    if try !event.galleries.isAttached(asset) {
      try event.galleries.add(asset)
    }
    
    return Response(redirect: "/events/\(id)")
  }
  
  public func uploadView(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let event = try Event.find(id) else {
      return Response(redirect: "/events")
    }
    
    var results = try ["event": event.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("events/upload", results)
  }
}
