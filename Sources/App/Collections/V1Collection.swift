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
    
    // MARK: - User Controller
    let userController = UserController()
    // web
    builder.grouped(AuthenticateMiddleware(), AdminMiddleware()).group("users") { user in
      user.get("/", handler: userController.index)
      user.post("/", handler: userController.store)
      user.patch(":userId", handler: userController.update)
      user.delete(":userId", handler: userController.destroy)
    }
    // api
    api.grouped(AuthenticateMiddleware(), AdminMiddleware()).group("users") { user in
      user.get("/", handler: userController.index)
      user.get(":userId", handler: userController.show)
    }
    api.post("auth", "login", handler: userController.login)
  
    // MARK: - Assets Controller
    let assetsController = AssetController()
    api.grouped(AuthenticateMiddleware()).resource("assets", assetsController)
    
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
