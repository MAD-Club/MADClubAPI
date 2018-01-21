//
//  DateTimeFormat.swift
//  App
//
//  Created by Johnny Nguyen on 2018-01-21.
//

import Foundation
import Vapor
import Leaf

public class DateTimeFormat: BasicTag {
  public let name = "datetimeformat"
  
  public func run(arguments: ArgumentList) throws -> Node? {
    guard let value = arguments[0], let date = value.date else { return nil }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm"
    let stringDate = dateFormatter.string(from: date)
    
    return Node.string(stringDate)
  }
}

