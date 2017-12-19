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
  
  /**
   Sets up the API keys from initializing
  **/
  public init(appId: String, apiKey: String) {
    self.appId = appId
    self.apiKey = apiKey
  }
  
  /**
   A conveinence initalizer used to set up through the `Config` file. This is from the secrets folder
  **/
  public convenience init(config: Config) throws {
    self.init(
      appId: try config.get("appId"),
      apiKey: try config.get("apiKey")
    )
  }
}
