import UIKit
import PhoenixKitsuCore
import Requestable

// codebeat:disable[TOO_MANY_IVARS]
class PhoenixItemTableViewController<T: HasKitsuObjectAttributes & Requestable> :
UITableViewController {
  var filters: [String : String] = [:]
  var items: [T] = []
  var latestNextLink: String?
  var cellIdentifier: String?
  
  private(set) var kitsuHandler: KitsuHandler!
}
// codebeat:enable[TOO_MANY_IVARS]

extension PhoenixItemTableViewController : HasKitsuHandler {
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
}
