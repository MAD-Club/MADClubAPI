//
//  Routes.swift
//  App
//
//  Created by Johnny Nguyen on 2017-11-30.
//

import Vapor
import HTTP

extension Droplet {
  public func setupRoutes() throws {
    //: MARK - UserController
    let userVC = UserController()
    resource("users", userVC)
  }
}
