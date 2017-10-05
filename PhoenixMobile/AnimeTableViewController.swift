//
//  TableViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 10/03/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit
import PhoenixCoreSwift

class AnimeTableViewController: UITableViewController {
  private let dataType = Anime.self
  private var items: [Anime] = []
  private var latestNextLink: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Anime"

    let nc = NotificationCenter.default
    _ = nc.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    let filters = ["text": "titan"]

    do {
      try PhoenixCore.getCollection(ofType: dataType, withFilters: filters) { searchResult in
        if let result = searchResult {
          DispatchQueue.main.async {
            self.items = (result.list as! [Anime])
            self.latestNextLink = result.pagingLinks.next
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
        }
      }
    } catch PhoenixError.invalidURL(let reason, _){
      print(reason)
    } catch {
      print(error.localizedDescription)
    }
  }

  private func catchNotification(notification: Notification) {
    self.tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? AnimeDetailController {
      detailcontroller.anime = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

    let anime = items[indexPath.row]

    var titleLanguageEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguagePreferenceString = UserDefaults.standard.string(forKey: "display_language_preference") {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguagePreferenceString)!
    }

    cell.textLabel?.text = anime.getTitleWith(identifier: titleLanguageEnum)
    cell.detailTextLabel?.text = anime.attributes?.slug

    return cell
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let frameHeight = scrollView.frame.size.height
    let doingRequest = UIApplication.shared.isNetworkActivityIndicatorVisible

    if offsetY > contentHeight - frameHeight, doingRequest == false, let next = latestNextLink {

      UIApplication.shared.isNetworkActivityIndicatorVisible = true

      //only prevents adding to list not firing request.
      do {
        try PhoenixCore.getCollection(ofType: dataType, byURL: next) { searchResult in
          if let result = searchResult {
            DispatchQueue.main.async {
              if self.latestNextLink != result.pagingLinks.next {
                self.latestNextLink = result.pagingLinks.next
                self.items.append(contentsOf: (result.list as! [Anime]))
                self.tableView.reloadData()
              }
              UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
          }
        }
      } catch {
        print(error.localizedDescription) //TODO: handle error
      }
    }
  }
}
