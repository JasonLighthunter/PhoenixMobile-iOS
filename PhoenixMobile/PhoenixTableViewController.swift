//
//  PhoenixTableViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 09/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.
//

import Foundation

import UIKit
import PhoenixCoreSwift

class PhoenixTableViewController: UITableViewController {
  internal var latestNextLink: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    let nc = NotificationCenter.default
    _ = nc.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  private func catchNotification(notification: Notification) {
    self.tableView.reloadData()
  }

  internal func addResultToItems<T>(_ result: KitsuSearchResult<T>) {
    if self.latestNextLink != result.pagingLinks?.next {
      self.latestNextLink = result.pagingLinks?.next
      self.tableView.reloadData()
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

  internal func getTitleLanguageEnum() -> TitleLanguageIdentifierEnum {
    guard let titleLanguagePreferenceString = UserDefaults.standard.string(forKey: "display_language_preference") else {
      return TitleLanguageIdentifierEnum.canonical
    }
    return TitleLanguageIdentifierEnum(rawValue: titleLanguagePreferenceString)!
  }
}
