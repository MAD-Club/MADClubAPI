import Foundation
import Vapor
import Leaf

public class DateFormat: BasicTag {
  public let name = "dateformat"
  
  public func run(arguments: ArgumentList) throws -> Node? {
    guard let value = arguments[0], let date = value.date else { return nil }
    
    let defaultFormat = DateFormatter.defaultFormat
    let stringDate = defaultFormat.string(from: date)
    
    return Node.string(stringDate)
  }
}
