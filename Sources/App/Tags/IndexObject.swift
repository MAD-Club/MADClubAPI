//
//  GalleryUrl.swift
//  App
//
//  Created by Johnny Nguyen on 2017-12-19.
//

import Foundation
import Vapor
import Leaf

public class IndexObject: BasicTag {
  public let name = "galleryUrl"
  
  public func run(arguments: ArgumentList) throws -> Node? {
    guard
      arguments.count == 3,
      let array = arguments[0]?.array,
      let index = arguments[1]?.int,
      let prop = arguments[2]?.string,
      index < array.count
      else { return nil }
    
    return array[index][prop]
  }
}
