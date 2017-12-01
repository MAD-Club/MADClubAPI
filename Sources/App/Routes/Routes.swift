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
    //: MARK - API V1 Collection
    try collection(V1Collection.self)
  }
}
