import UIKit
import PhoenixKitsuCore
import Requestable

class PhoenixItemTableViewController<T: HasKitsuObjectAttributes & Requestable> :
UITableViewController {
  var filters: [String : String] = [:]
  var items: [T] = []
  var latestNextLink: String?
  var cellIdentifier: String?
  
  private(set) var kitsuHandler: KitsuHandler!
}

extension PhoenixItemTableViewController : HasKitsuHandler {
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
}
