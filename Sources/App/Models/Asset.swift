//
//  Asset.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-19.
//

import Foundation
import Vapor
import FluentProvider

public final class Asset: Model, Timestampable {
  //MARK: Properties
  public var url: String
  public var type: String
  public var size: Int64
  public var fileId: String
  
  // MARK: Storage
  public let storage: Storage = Storage()
  
  /**
    Creates an asset model, that's referenced from a file storage or our own API
   
   - parameters:
     - url: String - the url path for the file
     - type: String - The file type
     - size: Int64 - The file size
  **/
  public init(url: String, type: String, size: Int64, fileId: String) {
    self.url = url
    self.type = type
    self.size = size
    self.fileId = fileId
  }
  
  public init(row: Row) throws {
    url = try row.get("url")
    type = try row.get("type")
    size = try row.get("size")
    fileId = try row.get("fileId")
  }
  
  public func makeRow() throws -> Row {
    var row = Row()
    try row.set("url", url)
    try row.set("type", type)
    try row.set("size", size)
    try row.set("fileId", fileId)
    return row
  }
}

//MARK: Database
extension Asset: Preparation {
  public static func prepare(_ database: Database) throws {
    try database.create(self) { asset in
      asset.id()
      asset.string("url")
      asset.string("type")
      asset.string("size")
      asset.string("fileId")
    }
  }
  
  public static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

//MARK: JSONRepresentable
extension Asset: JSONRepresentable {
  public func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set("id", id)
    try json.set("url", url)
    try json.set("type", type)
    try json.set("size", size)
    try json.set("fileId", fileId)
    try json.set("createdAt", createdAt)
    try json.set("updatedAt", updatedAt)
    return json
  }
}
