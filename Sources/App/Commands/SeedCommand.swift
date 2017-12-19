//
//  SeedCommand.Swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Foundation
import Vapor
import Console

public final class SeedCommand: Command {
  public let id = "seed"
  public let help = ["Prepares initial data for seeding."]
  public let console: ConsoleProtocol
  
  private let environment: Environment
  
  public init(console: ConsoleProtocol, environment: Environment) {
    self.console = console
  }
  
  fileprivate func prepareEvents() {
    
  }
  
  public func run(arguments: [String]) throws {
    console.print("Running seed command...")
    if environment == .development {
      
    }
  }
}

//MARK: ConfigInitializable
extension SeedCommand: ConfigInitializable {
  public convenience init(config: Config) throws {
    let console = try config.resolveConsole()
    self.init(console: console, environment: config.environment)
  }
}
