//
//  WebCollection.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-18.
//

import Foundation
import Vapor
import HTTP

/**
 The WebCollection will consist of all routes directly involved with the website
 This is to ensure that we're kept to being organized. We may be duplicating code, but since we're taking the monotholic approach,
 it's hard to keep it DTY as we can. We want to showcase both inputs
*/
public final class WebCollection: RouteCollection {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  public func build(_ builder: RouteBuilder) throws {
    // MARK: - User Controller
    let userController = UserController(view)
    
    builder.group("users") { user in
      user.get("login", handler: userController.loginView)
      user.post("login", handler: userController.loginWebPost)
      user.get("logout", handler: userController.logout)
    }
    
    builder.group("board") { board in
      board.get("/", handler: userController.index)
      board.grouped(AuthenticateMiddleware(), AdminMiddleware()).post("/", handler: userController.store)
      board.grouped(AuthenticateMiddleware(), AdminMiddleware()).patch(":id", handler: userController.update)
    }
    
    // MARK: Events Web View
    let eventController = EventController(view)
    
    let events = builder.grouped("events")
    events.get("/", handler: eventController.index)
    events.get("/", ":id", handler: eventController.show)
    events.grouped(AuthenticateMiddleware(), AdminMiddleware()).post("/", handler: eventController.createEvent)
    events.grouped(AuthenticateMiddleware(), AdminMiddleware()).get("create", handler: eventController.createEventView)
    events.grouped(AuthenticateMiddleware(), AdminMiddleware()).get(":id", "upload", handler: eventController.uploadView)
    events.grouped(AuthenticateMiddleware(), AdminMiddleware()).post(":id", "upload", handler: eventController.uploadImageForEvent)
    events.grouped(AuthenticateMiddleware(), AdminMiddleware()).get(":id", "edit", handler: eventController.editEventView)
    events.grouped(AuthenticateMiddleware(), AdminMiddleware()).post(":id", "edit", handler: eventController.editEvent)
    
    // MARK: News
    let newsController = NewsController(view)
    
    let news = builder.grouped("news")
    news.get("/", handler: newsController.index)
    news.get("/", ":id", handler: newsController.show)
    news.grouped(AuthenticateMiddleware(), AdminMiddleware()).post("/", handler: newsController.storeNews)
    news.grouped(AuthenticateMiddleware(), AdminMiddleware()).get("create", handler: newsController.storeNewsView)
    news.grouped(AuthenticateMiddleware(), AdminMiddleware()).get(":id", "edit", handler: newsController.editNewsView)
    news.grouped(AuthenticateMiddleware(), AdminMiddleware()).post(":id", "edit", handler: newsController.editNews)
    
    // MARK: - HomeController
    let homeController = HomeController(view)
    builder.get("/", handler: homeController.index)
    builder.get("about", handler: homeController.about)
  }
}
