//
//  HomeController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-04.
//

import Vapor
import HTTP

/**
 * This home controller should entail the basic details of what route it should provide
 *
**/
public final class HomeController {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  public func index(_ req: Request) throws -> ResponseRepresentable {
    // we're gonna create a limit of 1 events and 1 news
//    let events = try Event.makeQuery().sort("createdAt", .ascending).filter("eventTypeId", EventType.Category.event.id()).limit(3).all()
    let news = try News.makeQuery().sort("createdAt", .ascending).limit(3).all()
    return try view.make("index", ["news": news.makeJSON()])
  }
  
  /**
   Probably static information about the MAD Club.
   THere's not much I can really put in here right
  */
  public func info(_ req: Request) throws -> ResponseRepresentable {
    return try view.make("info")
  }
}
