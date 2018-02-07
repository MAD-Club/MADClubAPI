// AuthenticateMiddleware.swift
// Created by: JohnnyNguyen
// Updated: Dec. 19 2017

import Foundation
import Vapor
import HTTP
import Sessions
import JWTProvider
import JWT

/**
 This authentication middleware is used for protecting specific routes that we need a user to login.
 Sometimes we may need the user to be an admin in order for us to get through
**/
public final class AuthenticateMiddleware: Middleware {
  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    if request.accept.prefers("html") {
      // here we'll need to check for sessions
      let session = try request.assertSession()
      guard let userId = session.data["userId"]?.int else {
        return Response(redirect: "/")
      }
      
      guard try User.find(userId) != nil else {
        return Response(redirect: "/")
      }
      
    } else {
      // check for token (JWT) in this case for mobile devices
      guard let token = request.headers["Authorization"]?.string else {
        throw Abort(.forbidden, reason: "No token found!")
      }
      
      // attempt to verify token
      guard let key = drop?.config["jwt", "login"]?.string else {
        throw Abort(.internalServerError, reason: "Please contact the system administrator.")
      }
      
      let jwt = try JWT(token: token)
      
      do {
        try jwt.verifySignature(using: HS512(key: key.bytes))
      } catch {
        throw Abort(.forbidden, reason: "This token is invalid!")
      }
      
      // check if time has expired. If not, then we can continue on
      guard let exp = jwt.payload["exp"]?.int, TimeInterval(exp) > Date().timeIntervalSince1970 else {
        throw Abort(.unauthorized, reason: "Expired Token, please re-login")
      }
      
      let userId: Int = try jwt.payload.get("userId")
      
      guard try User.find(userId) != nil else {
        throw Abort(.notFound, reason: "This user does not exist!")
      }
      
      // set the userId to headers, for later use
      request.headers["userId"] = String(userId)
    }
    
    return try next.respond(to: request)
  }
}
