//
//  EventController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Vapor
import HTTP

public final class EventController: ResourceRepresentable, EmptyInitializable {
  
  public init() { }
  
  public func index(_ req: Request) throws -> ResponseRepresentable {
    
  }
  
  public func makeResource() -> Resource<Event> {
    return Resource(
      index: index
//      create: <#T##Resource.Multiple?##Resource.Multiple?##(Request) throws -> ResponseRepresentable#>,
//      store: <#T##Resource.Multiple?##Resource.Multiple?##(Request) throws -> ResponseRepresentable#>,
//      show: <#T##((Request, _) throws -> ResponseRepresentable)?##((Request, _) throws -> ResponseRepresentable)?##(Request, _) throws -> ResponseRepresentable#>,
//      edit: <#T##((Request, _) throws -> ResponseRepresentable)?##((Request, _) throws -> ResponseRepresentable)?##(Request, _) throws -> ResponseRepresentable#>,
//      update: <#T##((Request, _) throws -> ResponseRepresentable)?##((Request, _) throws -> ResponseRepresentable)?##(Request, _) throws -> ResponseRepresentable#>,
//      replace: <#T##((Request, _) throws -> ResponseRepresentable)?##((Request, _) throws -> ResponseRepresentable)?##(Request, _) throws -> ResponseRepresentable#>,
//      destroy: <#T##((Request, _) throws -> ResponseRepresentable)?##((Request, _) throws -> ResponseRepresentable)?##(Request, _) throws -> ResponseRepresentable#>
    )
  }
}
