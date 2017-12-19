// KloudlessService.swift
// Created by: Johnny Nguyen
// Dec. 19 2017

import Vapor
import HTTP
import Foundation

/**
 This class is a service request to the file API
**/
public class KloudlessService {
  //MARK: Properties
  private let apiKey: String
  private let appId: String
  private let accountId: Int
  
  //MARK: Private properties
  private let baseUrl: String = "https://api.kloudless.com/v1"
  
  /**
   Sets up the API keys from initializing
  **/
  public init(appId: String, apiKey: String, accountId: Int) {
    self.appId = appId
    self.apiKey = apiKey
    self.accountId = accountId
  }
  
  /**
   A conveinence initalizer used to set up through the `Config` file. This is from the secrets folder
  **/
  public convenience init(config: Config) throws {
    self.init(
      appId: try config.get("appId"),
      apiKey: try config.get("apiKey"),
      accountId: try config.get("accountId")
    )
  }
  
  /**
   Uploads a file, based on the set parameters
   
   - parameters:
     - fileName: String value, used to get the file name
     - file: The actual contents of the file, it'll be loaded into GDrive
  **/
  public func uploadFile(fileName: String, file: Data) throws -> JSON {
    guard let parentId = try createFolder() else {
      throw Abort(.forbidden, reason: "Could not get the item!")
    }
    
    let fileUploadUrl = "\(baseUrl)/accounts/\(accountId)/storage/files"
    
    // create json to put in headers
    var json = JSON()
    try json.set("name", fileName)
    try json.set("parent_id", parentId)
    
    // turn into a string
    guard let jsonString = json.makeBody().bytes?.makeString() else {
      throw Abort(.internalServerError, reason: "Could not successfully convert into a string value JSON")
    }
    
    // create the header
    let headers: [HeaderKey: String] = [
      .authorization: "APIKey \(apiKey)",
      .contentType: "application/octet-stream",
      .contentLength: "\(file.count)",
      HeaderKey(stringLiteral: "X-Kloudless-Metadata"): jsonString
    ]
    
    let request = Request(
      method: .get,
      uri: fileUploadUrl,
      headers: headers
    )
    
    let client = try EngineClient.factory.respond(to: request)
    guard let responseJSON = client.json else { throw Abort.badRequest }
    
    // create a downloadable link for us
    let downloadableLinkJSON = try createDownloadableLink(fileId: responseJSON.get("id"))
    let asset = try Asset(
      url: downloadableLinkJSON.get("url"),
      type: responseJSON.get("mime_type"),
      size: responseJSON.get("size"),
      fileId: responseJSON.get("id")
    )
    
    try asset.save()
    
    return try asset.makeJSON()
  }
  
  /**
   Creates a url path for us to use as the image source
  **/
  private func createDownloadableLink(fileId: String) throws -> JSON {
    let linkPath = "\(baseUrl)/accounts/\(accountId)/storage/links/"
    
    // create header
    let headers: [HeaderKey: String] = [
      .authorization: "APIKey \(apiKey)",
      .contentType: "application/json"
    ]
    
    // create body response
    var json = JSON()
    try json.set("file_id", fileId)
    try json.set("direct", true)
    
    // create request
    let request = Request(
      method: .post,
      uri: linkPath,
      headers: headers,
      body: json.makeBody()
    )
    
    let client = try EngineClient.factory.respond(to: request)
    guard let responseJSON = client.json else { throw Abort(.badRequest, reason: "Could not get retrieve contents!") }
    
    return responseJSON
  }
  
  /**
   This creates a folder for organizing. Once created, it'll return us the parentId or folderId
   
   - returns: Parent Folder Id
  **/
  private func createFolder() throws -> Int? {
    let storageUrl = "\(baseUrl)/accounts/\(accountId)/storage/folders"
    
    // Setup the request
    let request = Request(
      method: .post,
      uri: storageUrl,
      headers: ["Content-type": "application/json"]
    )
    
    let reponse = try EngineClient.factory.respond(to: request)
    return reponse.json?["id"]?.int
  }
}
