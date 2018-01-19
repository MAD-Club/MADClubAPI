//
//  UpdateEventTable.swift
//  web
//
//  Created by Johnny Nguyen on 2018-01-18.
//

import Vapor
import FluentProvider

public final class UpdateEventTable: Preparation {
  // the "up" function for those who are into rails/laravel for migrations
  public static func prepare(_ database: Database) throws {
    
  }
  
  // the "down" function for those who are into rails/laravel when migrating
  public static func revert(_ database: Database) throws { }
}
