//
//  AdminMiddleware.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-19.
//

import Foundation
import Vapor
import HTTP

public final class AdminMiddleware: Middleware {
  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    
    if request.accept.prefers("html") {
      let session = try request.assertSession()
      
      guard let userId = session.data["userId"]?.int else {
        throw Abort.badRequest
      }
      
      guard let user = try User.find(userId) else {
        throw Abort(.notFound, reason: "This user does not exist!")
      }
      
      guard user.admin else { throw Abort(.forbidden, reason: "You don't have permission to access this content!") }
      
    } else {
      // we can use the headers from last time. Remember this is used from the JWT. JWT should be used for either
      // front-end frameworks like React, Angular, or using Mobile Apps
      guard let userId = request.headers["userId"]?.int else {
        throw Abort.badRequest
      }
      
      guard let user = try User.find(userId) else {
        throw Abort(.notFound, reason: "This user does not exist!")
      }
      
      guard user.admin else { throw Abort(.forbidden, reason: "You don't have permission to access this content!") }
    }
    return try next.respond(to: request)
  }
}
