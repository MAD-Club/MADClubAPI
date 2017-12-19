//
//  Gallery.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-19.
//

import Foundation
import Vapor
import FluentProvider

// we've could of used a Pivot table, but we need the Timestampable included, so sadly this is our option
public final class Gallery: Model, Timestampable {
  //MARK: Properties
  public var eventId: Identifier
  public var assetId: Identifier
  
  public var storage: Storage = Storage()
  
  /**
   Creates the gallery from the related event and asset
  **/
  public init(assetId: Identifier, eventId: Identifier) {
    self.assetId = assetId
    self.eventId = eventId
  }
  
  public func makeRow() throws -> Row {
    var row = Row()
    try row.set("eventId", eventId)
    try row.set("assetId", assetId)
    return row
  }
  
  public init(row: Row) throws {
    eventId = try row.get("eventId")
    assetId = try row.get("assetId")
  }
}

//MARK: Parent Properties
extension Gallery {
  public var event: Parent<Gallery, Event> {
    return parent(id: eventId)
  }
  
  public var asset: Parent<Gallery, Asset> {
    return parent(id: assetId)
  }
}

//MARK: Preparation
extension Gallery: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { gallery in
      gallery.id()
      gallery.parent(Asset.self)
      gallery.parent(Event.self)
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

//MARK: JSONRepresentable
extension Gallery: JSONRepresentable {
  public func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("event", event.get()?.makeJSON())
    try json.set("asset", asset.get()?.makeJSON())
    try json.set("createdAt", createdAt)
    try json.set("updatedAt", updatedAt)
    return json
  }
}
