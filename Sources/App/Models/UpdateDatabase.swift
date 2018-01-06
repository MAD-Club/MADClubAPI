//
//  Migration.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Foundation
import Vapor
import FluentProvider

/// This is our "migration" app, this'll run before preparing other apps.
public struct UpdateDatabase: Preparation {
  public static func prepare(_ database: Database) throws {
    
  }
  
  // nothing really goes here
  public static func revert(_ database: Database) throws { }
}
