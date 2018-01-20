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
    return try New.makeQuery()
      .all()
      .makeJSON()
  }
  
  /**
   Showcases the index page of a request
  */
  public func index(_ req: Request) throws -> ResponseRepresentable {
    let news = try New.makeQuery().all()
    var results = ["news": try news.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("news/index", results)
  }
  
  /**
   Creates a new page, POST request, for web-pages
  */
  public func storeNews(_ req: Request) throws -> ResponseRepresentable {
    guard let title = req.formData?["title"]?.string,
      let content = req.formData?["content"]?.string else {
        return try view.make("news/index", ["error": "Invalid fields!"])
    }
    
    let news = New(title: title, content: content)
    try news.save()
    
    return Response(redirect: "news")
  }
  
  /**
    The GET Request, for which it's starting to create the website
  */
  public func storeNewsView(_ req: Request) throws -> ResponseRepresentable {
    return try view.make("news/create")
  }
}
