//
//  UserController.swift
//  App
//
//  Created by Johnny Nguyen on 2017-11-06.
//

import Vapor
import BCrypt
import HTTP
import JWT
import JWTProvider

public final class UserController {
  private let view: ViewRenderer
  
  public init(_ view: ViewRenderer) {
    self.view = view
  }
  
  /**
   LoginView
  */
  public func loginView(_ req: Request) throws -> ResponseRepresentable {
    let session = try req.assertSession()
    
    if let _ = session.data["userId"]?.int {
      return Response(redirect: "/")
    }
    
    return try view.make("login")
  }
  
  /**
    Logs the user out. This only works for web, since JWT tokens can be disposed through a localStorage
  */
  public func logout(_ req: Request) throws -> ResponseRepresentable {
    try req.assertSession().destroy()
    return Response(redirect: "/")
  }
  
  /**
    Attempts to log the user in
  **/
  public func loginWebPost(_ req: Request) throws -> ResponseRepresentable {
    guard let email = req.formURLEncoded?["email"]?.string, let password = req.formURLEncoded?["password"]?.string else {
      return try view.make("login", ["error": "Invalid credentials!"])
    }
    
    guard !email.isEmpty || password.isEmpty else {
      return try view.make("login", ["error": "Empty fields!"])
    }
    
    guard let user = try User.makeQuery().filter("email", email.lowercased()).first() else {
      return try view.make("login", ["error": "This user doesn't exist!"])
    }
    
    guard try Hash.verify(message: password, matches: user.password) else {
      return try view.make("login", ["error": "Invalid credentials!"])
    }
    
    // start the session call based if html or mobile
    let session = try req.assertSession()
    try session.data.set("userId", user.id?.int)
    return Response(redirect: "/")
  }
  
  public func loginAPIPost(_ req: Request) throws -> ResponseRepresentable {
    guard let email = req.json?["email"]?.string, let password = req.json?["password"]?.string else {
      throw Abort.badRequest
    }
    
    guard let user = try User.makeQuery().filter("email", email.lowercased()).first() else {
      throw Abort.notFound
    }
    
    guard try Hash.verify(message: password, matches: user.password) else {
      throw Abort(.forbidden, reason: "Invalid user credentials!")
    }
    
    // use JWT --> 86400 = 1 Day expiration
    var payload = JSON(ExpirationTimeClaim(createTimestamp: { Int(Date().timeIntervalSince1970) + 86400 }))
    try payload.set("userId", user.id)
    
    // create jwt
    guard let key = drop?.config["jwt", "login"]?.string else { throw Abort.serverError }
    let jwt: JWT = try JWT(payload: payload, signer: HS512(key: key.bytes))
    
    var json = JSON()
    try json.set("token", jwt.createToken())
    
    return json
  }
  
  /**
    Shows all users
   **/
  public func index(_ req: Request) throws -> ResponseRepresentable {
    return try User.all().makeJSON()
  }
  
  /**
    Showcases users
   **/
  public func show(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.user()
    return try user.makeJSON()
  }
  
  /**
    Creates a user for us
   **/
  public func store(_ req: Request) throws -> ResponseRepresentable {
    guard
      let email = req.data["email"]?.string,
      let password = req.data["password"]?.string,
      let role = req.data["role"]?.string else {
        throw Abort.badRequest
    }
    
    guard try User.makeQuery().filter("email", email.lowercased()).first() == nil else {
      throw Abort(.conflict, reason: "This email address already exists! Do you already have an account?")
    }
    
    let user = try User(email: email, role: role, password: password)
    try user.save()
    
    return Response(redirect: "/")
  }
  
  /**
    Makes changes to a specific user, based on the id
  **/
  public func update(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.user()
    
    // change up user passwords
    if let email = req.data["email"]?.string {
      guard !email.isEmpty else { throw Abort(.conflict, reason: "Email address cannot be empty!") }
      user.email = email
    }
    if let password = req.data["password"]?.string {
      guard !password.isEmpty else { throw Abort(.conflict, reason: "Password can't be empty!") }
      user.password = try Hash.make(message: password).makeString()
    }
    try user.save()
    // return back to the start
    return Response(redirect: "/")
  }
  
  /**
    Destroys the user, deletes the user from the database
  **/
  public func destroy(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.user()
    try user.delete()
    return Response(redirect: "/")
  }
}

extension Request {
  fileprivate func user() throws -> User {
    guard let userId = parameters["userId"]?.int else {
      throw Abort.notFound
    }
    
    guard let user = try User.find(userId) else {
      throw Abort.notFound
    }
    
    return user
  }
}
