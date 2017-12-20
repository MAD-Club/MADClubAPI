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

public final class UserController: ResourceRepresentable {
  /**
    Logs the user in
  **/
  public func login(_ req: Request) throws -> ResponseRepresentable {
    guard let email = req.data["email"]?.string,
          let password = req.data["password"]?.string else {
      throw Abort.notFound
    }
    
    guard let user = try User.makeQuery().filter("email", email.lowercased()).first() else {
      throw Abort.notFound
    }
    
    guard try Hash.verify(message: password, matches: user.password) else {
      throw Abort(.forbidden, reason: "Invalid user credentials!")
    }
    
    // start the session call based if html or mobile
    if req.accept.prefers("html") {
      let session = try req.assertSession()
      try session.data.set("userId", user.id?.int)
      return Response(redirect: "/")
    } else {
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
  }
  
  public func index(_ req: Request) throws -> ResponseRepresentable {
    return try User.all().makeJSON()
  }
  
  public func show(_ req: Request, user: User) throws -> ResponseRepresentable {
    return try user.makeJSON()
  }
  
  public func store(_ req: Request) throws -> ResponseRepresentable {
    guard
      let email = req.data["email"]?.string,
      let password = req.data["password"]?.string else {
        throw Abort.badRequest
    }
    
    guard try User.makeQuery().filter("email", email.lowercased()).first() == nil else {
      throw Abort(.conflict, reason: "This email address already exists! Do you already have an account?")
    }
    
    let user = try User(email: email, password: password)
    try user.save()
    
    return Response(redirect: "/")
  }
  
  public func update(_ req: Request, user: User) throws -> ResponseRepresentable {
    user.email = req.data["email"]?.string ?? user.email
    
    if let password = req.data["password"]?.string {
      user.password = try Hash.make(message: password).makeString()
    }
    try user.save()
    
    return Response(redirect: "/")
  }
  
  public func destroy(_ req: Request, user: User) throws -> ResponseRepresentable {
    try user.delete()
    return Response(redirect: "/")
  }
  
  public func makeResource() -> Resource<User> {
    return Resource(
      index: index,
      store: store,
      show: show,
      update: update,
      destroy: destroy
    )
  }
}
