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

    // MARK: EventController
    let eventController = EventController(view)
    
    api.grouped(APIMiddleware()).group("events") { events in
      events.get("/", handler: eventController.all)
    }
    
    // MARK: NewsController
    let newsController = NewsController(view)
    
    api.grouped(APIMiddleware()).group("news") { news in
      news.get("/", handler: newsController.all)
      news.get("/", ":id", handler: newsController.getNews)
    }
  
    // MARK: Events API
    api.grouped(APIMiddleware()).group("events") { event in
      event.get("/", handler: eventController.all)
      event.get("/", ":id", handler: newsController.getNews)
    }
  }
}
