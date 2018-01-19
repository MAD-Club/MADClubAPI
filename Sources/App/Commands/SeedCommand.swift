//
//  SeedCommand.Swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-18.
//

import Foundation
import Vapor
import Console
import PostgreSQL

public final class SeedCommand: Command {
  public let id = "seed"
  public let help = ["Prepares initial data for seeding."]
  public let console: ConsoleProtocol
  
  private let environment: Environment
  private let events: [Config]?
  private let user: [String: Config]?
  
  public init(console: ConsoleProtocol, config: Config) {
    self.console = console
    self.environment = config.environment
    events = config["seed", "events"]?.array
    user = config["seed", "user"]?.object
  }
  
  /**
   Prepares the Event Types. This is initial data, so it's critical we have this.
   We shouldn't really require a json for this so we'll add it like so
  */
  fileprivate func prepareEventType() throws {
    console.print("Adding Event Types...")
    let types: [String] = ["meetup", "event"]
    types.forEach { type in
      let eventType = EventType(type: type)
      do {
        try eventType.save()
        console.print("Saved successfully!")
      } catch let e {
        console.print(e.localizedDescription)
      }
    }
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
      // Create event, (1 is meetup, 2 is event)
      let eventObject = Event(eventTypeId: 2, title: title, content: content)
      
      do {
        try eventObject.save()
        console.print("Added event: \(eventObject.title)-\(eventObject.id?.int ?? 0)")
      } catch let error as PostgreSQLError {
        console.print("Could not save event: \(error.reason)")
      }
    }
  }
  
  /**
    Prepares the users seeding based on the environments given
   **/
  fileprivate func prepareUser() throws {
    console.print("adding test user")
    if let user = user, let email = user["email"]?.string, let password = user["password"]?.string {
      let userObject = try? User(email: email, password: password)
      try? userObject?.save()
      console.print("user saved!")
    }
  }
  
  public func run(arguments: [String]) throws {
    console.print("Running seed command...")
    try prepareEventType()
    if environment == .development {
      // we need to start deleting some stuff in our event as well
      try Event.makeQuery().delete()
      try User.makeQuery().delete()
      // then re-prepare duh
      try prepareEvents()
      try prepareUser()
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
