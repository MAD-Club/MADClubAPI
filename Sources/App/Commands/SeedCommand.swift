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
  public let id = "my-command"
  public let help = ["This command does things, like foo, and bar."]
  public let console: ConsoleProtocol
  
  public init(console: ConsoleProtocol) {
    self.console = console
  }
  
  public func run(arguments: [String]) throws {
    console.print("running custom command...")
  }
}

extension SeedCommand: ConfigInitializable {
  public convenience init(config: Config) throws {
    let console = try config.resolveConsole()
    self.init(console: console)
  }
}
