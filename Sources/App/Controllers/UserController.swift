//
//  UserController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-11-06.
//

import Vapor
import HTTP

public final class UserController: ResourceRepresentable {
  
  public init() { }
  
  public func makeResource() -> Resource<User> {
    return Resource()
  }
}

extension UserController: EmptyInitializable { }
