// AuthenticateMiddleware.swift
// Created by: JohnnyNguyen
// Updated: Dec. 19 2017

import Vapor
import HTTP

public final class AuthenticateMiddleware: Middleware {
  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    return try next.respond(to: request)
  }
}
