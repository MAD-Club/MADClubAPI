//
//  Node+.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-21.
//

import Foundation
import Vapor
import HTTP

/// another helper function, this will serve to get us custom dates
extension Node {
  public var customDate: Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm"
    // TODO: This probably needs to be re-adjusted, but for the time being this is oks
    return dateFormatter.date(from: self.string!) ?? Date()
  }
}
