//
//  APIMiddleware.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-21.
//

import Vapor
import HTTP

public final class APIMiddleware: Middleware {
  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    // we're going to be using this for our API
    guard let auth = request.headers["Authorization"]?.string else {
      throw Abort(.notFound, reason: "No authorization token found!")
    }
    
    guard let apiKey = drop?.config["api", "apiKey"]?.string else {
      throw Abort.serverError
    }
    
    guard auth == apiKey else {
      throw Abort(.unauthorized, reason: "Invalid Token!")
    }
    
    return try next.respond(to: request)
  }
}
