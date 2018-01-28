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
    var results = ["users": try User.all().makeJSON()]
    try req.user(array: &results)
    
    // if the query exists, we can attempt to delete
    // we'll do a dirty check if the user is an admin or not
    if let id = req.query?["id"]?.int, let user = try User.find(id) {
      if try req.getUserData().admin {
        try user.delete()
        return Response(redirect: "/board")
      }
    }
    
    return try view.make("board/index", results)
  }
  
  public func updateView(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let user = try User.find(id) else {
      return Response(redirect: "/board")
    }
    
    var results = ["member": try user.makeJSON()]
    try req.user(array: &results)
    
    return try view.make("board/edit", results)
  }
  
  /**
    Show one user
   **/
  public func update(_ req: Request) throws -> ResponseRepresentable {
    guard let id = req.parameters["id"]?.int, let user = try User.find(id) else {
      return Response(redirect: "/board")
    }
    
    user.role = req.formURLEncoded?["role"]?.string ?? user.role
    user.name = req.formURLEncoded?["name"]?.string ?? user.name
    
    try user.save()
    
    return Response(redirect: "/board")
  }
  
  /**
    Creates a user for us
   **/
  public func store(_ req: Request) throws -> ResponseRepresentable {
    guard
      let name = req.formURLEncoded?["name"]?.string,
      let email = req.formURLEncoded?["email"]?.string,
      let password = req.formURLEncoded?["password"]?.string,
      let role = req.formURLEncoded?["role"]?.string else {
        throw Abort.badRequest
    }
    
    guard try User.makeQuery().filter("email", email.lowercased()).first() == nil else {
      throw Abort(.conflict, reason: "This email address already exists! Do you already have an account?")
    }
    
    let user = try User(name: name, email: email, role: role, password: password)
    try user.save()
    
    return try Response(redirect: "/board")
  }
}
