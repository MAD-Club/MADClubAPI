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
    let userController = UserController(view)
    
    api.post("auth", "login", handler: userController.loginAPIPost)

    // api
    api.grouped(AuthenticateMiddleware(), AdminMiddleware()).group("users") { user in
      user.get("/", handler: userController.index)
      user.get(":userId", handler: userController.show)
    }
  
    // MARK: - Assets Controller
    let assetsController = AssetController()
    api.grouped(AuthenticateMiddleware()).resource("assets", assetsController)
    
    // MARK: - EventController
    let eventController = EventController(view)
    
    // MARK: Events API
    api.group("events") { event in
      event.get("/", handler: eventController.all)
    }
  }
}
