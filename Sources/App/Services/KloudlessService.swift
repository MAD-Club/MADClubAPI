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
   Uploads a video to Google Drive, and attempts to create a direct link from Kloudless.
   - parameters:
   - fileName: String - the filename of the file
   - file: Bytes - Wrapper for Bytes, in a BodyRepresentable
   **/
  public func uploadVideo(fileName: String, file: Bytes) throws -> JSON {
    guard let parentId = try createFolder(fileType: .images) else {
      throw Abort(.forbidden, reason: "Could not get the item!")
    }
    
    return try upload(fileName: fileName, file: file, parentId: parentId)
  }
  
  /**
   Uploads a document to Google Drive, and attempts to create a direct link from Kloudless.
   - parameters:
   - fileName: String - the filename of the file
   - file: Bytes - Wrapper for Bytes, in a BodyRepresentable
   **/
  public func uploadDocument(fileName: String, file: Bytes) throws -> JSON {
    guard let parentId = try createFolder(fileType: .documents) else {
      throw Abort(.forbidden, reason: "Could not get the item!")
    }
    
    return try upload(fileName: fileName, file: file, parentId: parentId)
  }
  
  /**
    Uploads an image to Google Drive, and attempts to create a direct link from Kloudless.
   - parameters:
     - fileName: String - the filename of the file
     - file: Bytes - Wrapper for Bytes, in a BodyRepresentable
  **/
  public func uploadImage(fileName: String, file: Bytes) throws -> JSON {
    guard let parentId = try createFolder(fileType: .images) else {
      throw Abort(.forbidden, reason: "Could not get the item!")
    }
    
    return try upload(fileName: fileName, file: file, parentId: parentId)
  }
  
  /**
   Uploads a file, based on the set parameters
   
   - parameters:
     - fileName: String value, used to get the file name
     - file: The actual contents of the file, it'll be loaded into GDrive
  **/
  private func upload(fileName: String, file: Bytes, parentId: String) throws -> JSON {
    let fileUploadUrl = "\(baseUrl)/accounts/\(accountId)/storage/files"
    
    // create json to put in headers
    var json = JSON()
    try json.set("name", fileName)
    try json.set("parent_id", parentId)
    
    // turn into a string
    let jsonString = try json.serialize().makeString()
    
    // create the header
    let headers: [HeaderKey: String] = [
      .authorization: "APIKey \(apiKey)",
      .contentType: "application/octet-stream",
      "X-Kloudless-Metadata": jsonString
    ]
    
    let request = Request(
      method: .post,
      uri: fileUploadUrl,
      headers: headers,
      body: Body.data(file).makeBody()
    )
    
    let client = try EngineClient.factory.respond(to: request)
    guard let responseJSON = client.json else { throw Abort.badRequest }
    
    // create a downloadable link for us
    let downloadableLinkJSON = try createDownloadableLink(fileId: responseJSON.get("id"))
    let asset = try Asset(
      fileName: fileName,
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
  private func createFolder(fileType type: FileType) throws -> String? {
    let storageUrl = "\(baseUrl)/accounts/\(accountId)/storage/folders"
    
    var json = JSON()
    try json.set("name", "madclub-\(type.rawValue)")
    try json.set("parent_id", "root")
    
    let headers: [HeaderKey: String] = [
      .contentType: "application/json",
      .authorization: "APIKey \(apiKey)"
    ]
    
    // Setup the request
    let request = Request(
      method: .post,
      uri: storageUrl,
      headers: headers,
      body: json.makeBody()
    )
    
    let response = try EngineClient.factory.respond(to: request)

    return response.json?["id"]?.string
  }
}

// MARK: Enum
extension KloudlessService {
  public enum FileType: String {
    case images
    case documents
    case videos
  }
}
