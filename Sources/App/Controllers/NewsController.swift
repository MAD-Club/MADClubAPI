//
//  NewsController.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-06.
//

import Foundation
import Vapor
import HTTP
import SwiftMarkdown

public final class NewsController {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  // MARK: API Calls
  
  /**
   Gets all events returned from query
   */
  public func all(_ req: Request) throws -> ResponseRepresentable {
    return try New.makeQuery()
      .all()
      .makeJSON()
  }
  
  /**
    Returns the event json based on the id
  */
  public func getNews(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int else {
      throw Abort.badRequest
    }
    
    guard let news = try New.find(id) else {
      throw Abort.notFound
    }
    
    return try news.makeJSON()
  }
  
  // MARK: Web Calls
  
  /**
   Showcases the index page of a request
  */
  public func index(_ req: Request) throws -> ResponseRepresentable {

    // if the query exists, we can attempt to delete
    if let newsId = req.query?["id"]?.int, let news = try New.find(newsId) {
      try news.delete()
      return Response(redirect: "/news")
    }
    
    // otherwise streamline the normal process
    let news = try New.makeQuery().all()
    var results = ["news": try news.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("news/index", results)
  }
  
  /**
    Showcases one news outlet
  */
  public func show(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let news = try New.find(id) else {
      return Response(redirect: "/news")
    }
    
    news.content = try markdownToHTML(news.content)
    var results = ["news": try news.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("news/show", results)
  }
  
  /**
   Creates a new page, POST request, for web-pages
  */
  public func storeNews(_ req: Request) throws -> ResponseRepresentable {
    guard let title = req.formURLEncoded?["title"]?.string,
      let content = req.formURLEncoded?["content"]?.string else {
        return try view.make("news/index", ["error": "Invalid fields!"])
    }
    
    let news = New(title: title, content: content)
    try news.save()
    
    return Response(redirect: "/news")
  }
  
  /**
    The GET Request, for which it's starting to create the website
  */
  public func storeNewsView(_ req: Request) throws -> ResponseRepresentable {
    return try view.make("news/create")
  }
  
  /**
    We want to edit the views. Sadly this is a post request, not a patch, since it requires the browser only supports GET/POST,
    Unless you want to be sneaky, and use a hidden input type
   */
  public func editNews(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let news = try New.find(id) else {
      return Response(redirect: "/news")
    }
    
    news.title = req.formURLEncoded?["title"]?.string ?? news.title
    news.content = req.formURLEncoded?["content"]?.string ?? news.content
    try news.save()
    
    return Response(redirect: "/news/\(id)")
  }
  
  /**
    This one showcases the edit news view
  */
  public func editNewsView(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let news = try New.find(id) else {
      return Response(redirect: "/news")
    }
    
    return try view.make("news/edit", ["news": news.makeJSON()])
  }
}
