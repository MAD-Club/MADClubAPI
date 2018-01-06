//
//  Session+.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-20.
//

import Vapor
import HTTP

// helper functions
extension Request {
  /**
    Session-helper function, checks for sessions for us
   **/
  public func user( array: inout [String: JSON]) throws {
    let session = try assertSession()
    // check if user exists and if it does, we're adding them in
    if let userId = session.data["userId"]?.int {
      guard let user = try User.find(userId) else {
        throw Abort.notFound
      }
      array["user"] = try user.makeJSON()
    }
  }
}
