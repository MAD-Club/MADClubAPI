//
//  V1Collection.swift
//  App
//
//  Created by Johnny Nguyen on 2017-11-30.
//

import Vapor
import HTTP

public final class V1Collection: RouteCollection {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  public func build(_ builder: RouteBuilder) throws {
    let api = builder.grouped("api", "v1")
    
    // MARK: - EventController
    let eventController = EventController(view)
    
    // MARK: Events API
    let eventsAPI = api.grouped("events")
    eventsAPI.get("/", handler: eventController.all)
    
    // MARK: Events Web View
    let events = builder.grouped("events")
    events.get("/", handler: eventController.index)
  
    // MARK: - HomeController
    let homeController = HomeController(view)
    builder.get("/", handler: homeController.index)
  }
}
