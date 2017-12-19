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
  
  public init(console: ConsoleProtocol) {
    self.console = console
  }
  
  public func run(arguments: [String]) throws {
    console.print("running custom command...")
    
  }
}

//MARK: ConfigInitializable
extension SeedCommand: ConfigInitializable {
  public convenience init(config: Config) throws {
    let console = try config.resolveConsole()
    // we set up our seeding files in here too
    // config["seed", ""] whatever
    self.init(console: console)
  }
}
