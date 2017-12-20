//
//  AssetController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-19.
//

import Foundation
import Vapor
import HTTP

public final class AssetController: ResourceRepresentable {
  
  /**
    Retrieves all the assets found
  **/
  public func index(_ req: Request) throws -> ResponseRepresentable {
    return try Asset.all().makeJSON()
  }
  
  /**
    Creates an asset, through a file storage api
  **/
  public func store(_ req: Request) throws -> ResponseRepresentable {
    guard let config = drop?.config, let kloudlessConfig: Config = try config.get("kloudless") else { throw Abort.serverError }
    
    let kloudless = try KloudlessService(config: kloudlessConfig)
    
    guard
      let fileName = req.formData?["file"]?.filename,
      let file = req.formData?["file"]?.part.body else {
        throw Abort.badRequest
    }
    
    guard let type = req.formData?["fileType"]?.string, let fileType = KloudlessService.FileType(rawValue: type) else {
        throw Abort(.conflict, reason: "Could not get file type!")
    }
    
    let results: JSON
    
    switch fileType {
    case .images:
      results = try kloudless.uploadImage(fileName: fileName, file: file)
    default:
      results = JSON()
    }

    return results
  }
  
  /**
    Showcases an asset, based on the file storage API
  **/
  public func show(_ req: Request, asset: Asset) throws -> ResponseRepresentable {
    return JSON()
  }
  
  /**
   updates an asset based on file storage API
  **/
  public func update(_ req: Request, asset: Asset) throws -> ResponseRepresentable {
    return JSON()
  }
  
  /**
    Destroys the asset, along with the file storage API too
  **/
  public func destroy(_ req: Request, asset: Asset) throws -> ResponseRepresentable {
    return JSON()
  }
  
  public func makeResource() -> Resource<Asset> {
    return Resource(
      index: index,
      store: store,
      show: show,
      update: update,
      destroy: destroy
    )
  }
}
