//
//  DropCommand.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-21.
//

import Foundation
import Vapor
import Console

/**
 DropCommand used to drop all of the tables in PostgreSQL, and will attempt to create a new one.
 WARNING: THIS WILL DELETE EVERYTHING SO RUN IF SURE.
*/
public final class DropCommand: Command {
  public let id = "seed"
  public let help = ["Prepares initial data for seeding."]
  public let console: ConsoleProtocol
  
  public init(console: ConsoleProtocol) {
    self.console = console
  }
  
  public func run(arguments: [String]) throws {
    try drop?.database?.raw("DROP SCHEMA public CASCADE;")
    try drop?.database?.raw("CREATE SCHEMA public;")
    try drop?.database?.raw("GRANT ALL ON SCHEMA public TO postgres;")
    try drop?.database?.raw("GRANT ALL ON SCHEMA public TO public;")
  }
}

extension DropCommand: ConfigInitializable {
  public convenience init(config: Config) throws {
    try self.init(console: config.resolveConsole())
  }
}
