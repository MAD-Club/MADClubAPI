//
//  HomeController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-04.
//

import Vapor
import HTTP

/**
 * This home controller should entail the basic details of what route it should provide
 *
**/
public final class HomeController {
  let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  public func index(_ req: Request) throws -> ResponseRepresentable {
    return try view.make("index")
  }
}
