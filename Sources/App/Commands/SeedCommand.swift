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
  private let events: [Config]?
  
  public init(console: ConsoleProtocol, config: Config) {
    self.console = console
    self.environment = config.environment
    events = config["seed", "events"]?.array
  }
  
  /**
    Prepares the Events Seeding
  **/
  fileprivate func prepareEvents() throws {
    console.print("Beginning to add events..")
    guard let events = events else {
      console.print("Could not get retrieve events!")
      return
    }
    
    try events.forEach { event in
      let title: String = try event.get("title")
      let content: String = try event.get("content")
      // Create event
      let eventObject = Event(title: title, content: content)
      
      do {
        try eventObject.save()
        console.print("Added event: \(eventObject.title)-\(eventObject.id ?? 0)")
      } catch let error {
        console.print("Could not save event: \(error.localizedDescription)")
      }
    }
  }
  
  public func run(arguments: [String]) throws {
    console.print("Running seed command...")
    if environment == .development {
      try prepareEvents()
    }
  }
}

//MARK: ConfigInitializable
extension SeedCommand: ConfigInitializable {
  public convenience init(config: Config) throws {
    let console = try config.resolveConsole()
    self.init(console: console, config: config)
  }
}
