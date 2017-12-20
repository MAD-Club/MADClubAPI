// AuthenticateMiddleware.swift
// Created by: JohnnyNguyen
// Updated: Dec. 19 2017

import Vapor
import HTTP
import Sessions
import JWTProvider

/**
 This authentication middleware is used for protecting specific routes that we need a user to login.
 Sometimes we may need the user to be an admin in order for us to get through
**/
public final class AuthenticateMiddleware: Middleware {
  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    return try next.respond(to: request)
  }
}
