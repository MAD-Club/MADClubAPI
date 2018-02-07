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
import Random

/**
 Seed command to initially seed our database to whatever we want
*/
public final class SeedCommand: Command {
  public let id = "seed"
  public let help = ["Prepares initial data for seeding."]
  public let console: ConsoleProtocol
  
  private let environment: Environment
  private let events: [Config]?
  private let news: [Config]?
  private let users: [Config]?
  private let admin: Config?
  
  public init(console: ConsoleProtocol, config: Config) {
    self.console = console
    self.environment = config.environment
    events = config["seed", "events"]?.array
    news = config["seed", "news"]?.array
    users = config["seed", "users"]?.array
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
      let eventObject = Event(
        title: title,
        description: content,
        startDate: Date(),
        endDate: Date().addingTimeInterval(try Double(OSRandom.makeInt32()))
      )
      
      do {
        try eventObject.save()
        console.print("Added event: \(eventObject.title)-\(eventObject.id?.int ?? 0)")
      } catch let error as PostgreSQLError {
        console.print("Could not save event: \(error.reason)")
      }
    }
  }
  
  /**
   Prepares the News category seeding
  **/
  fileprivate func prepareNews() throws {
    console.print("Adding News...")
    guard let news = news else {
      console.print("Could not retrieve news!")
      return
    }
    
    try news.forEach { new in
      let title: String = try new.get("title")
      let content: String = try new.get("content")
      // create the news outlet
      let eventObject = New(title: title, content: content)
      
      do {
        try eventObject.save()
        console.print("Added news: \(eventObject.title)-\(eventObject.id?.int ?? 0)")
      } catch let error as PostgreSQLError {
        console.print("Could not save news: \(error.reason)")
      }
    }
  }
  
  /**
    Prepares the users seeding based on the environments given
   **/
  fileprivate func prepareUsers() throws {
    console.print("adding test user")
    if let users = users {
      try users.forEach { user in
        let userObject = try User(
          name: user.get("name"),
          email: user.get("email"),
          role: user.get("role"),
          password: user.get("password")
        )
        userObject.admin = try user.get("admin")
        try userObject.save()
        console.print("user saved!")
      }
    }
  }
  
  public func run(arguments: [String]) throws {
    console.print("Running seed command...")
    if environment == .development {
      // we need to start deleting some stuff in our event as well
      try Event.makeQuery().delete()
      try New.makeQuery().delete()
      try User.makeQuery().delete()
      // then re-prepare duh
      try prepareEvents()
      try prepareNews()
      try prepareUsers()
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
