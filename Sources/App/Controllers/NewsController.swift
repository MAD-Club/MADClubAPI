//
//  NewsController.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-06.
//

import Foundation
import Vapor
import HTTP

public final class NewsController {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  public func all(_ req: Request) throws -> ResponseRepresentable {
    return try News.makeQuery()
      .all()
      .makeJSON()
  }
  
  public func index(_ req: Request) throws -> ResponseRepresentable {
    let news = try Event.makeQuery().all()
    var results = ["news": try news.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("news", results)
  }
}
