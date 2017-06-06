//
//  TableViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 10/03/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit
import PhoenixCoreSwift

class TableViewController: UITableViewController {
  private var items: [Anime] = []
  private var latestNextLink: String?

  @IBOutlet weak var editButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Loading..."

    let nc = NotificationCenter.default
    _ = nc.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    PhoenixCore.initialize()

//    PhoenixCore.getResource(ofType: "anime", byId: 4227) { object, error in
//      let anime = object as? Anime
//      let animeAttr = anime?.attributes as? AnimeAttributes
//      print(anime.debugDescription)
//      print(animeAttr.debugDescription)
//      print("episodecount: \(String(describing: animeAttr?.episodeCount))")
//      print("test")  
//    }

    let filters = ["text": "titan"]

    PhoenixCore.getCollection(ofType: "anime", withFilters: filters) { searchResult, error in
      if let result = searchResult {
        DispatchQueue.main.async {
          self.items = (result.list as? [Anime])!
          self.title = "Search results for: \"\(filters["text"] ?? "NO SEARCH TEXT FOUND")\""
          self.latestNextLink = result.pagingLinks?.next
          self.tableView.reloadData()
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      } else {
        print(error?.localizedDescription ?? "Something went wrong") //TODO: handle error
      }
    }
  }

  @IBAction func onEditClick(_ sender: Any) {
    self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    let currentTitle = self.editButton.title
    self.editButton.title = (currentTitle == "Edit") ? "Done" : "Edit"
  }

  private func catchNotification(notification: Notification) {
    self.tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? DetailController {
      detailcontroller.anime = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    tableView.beginUpdates()
    tableView.deleteRows(at: [indexPath], with: .automatic)
    self.items.remove(at: indexPath.row)
    tableView.endUpdates()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

    let anime = items[indexPath.row]

    var titleLanguageEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguagePreferenceString = UserDefaults.standard.string(forKey: "display_language_preference") {
      titleLanguageEnum = TitleLanguageIdentifierEnum(titleLanguagePreferenceString)
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

      PhoenixCore.getCollection(ofType: "anime", byURL: next) { searchResult, error in
        if let result = searchResult {
          DispatchQueue.main.async {
            if self.latestNextLink != result.pagingLinks?.next {
              self.latestNextLink = result.pagingLinks?.next
              self.items.append(contentsOf: (result.list as? [Anime])!)
              self.tableView.reloadData()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
        } else {
          print(error?.localizedDescription ?? "Something went wrong")
        }
      }
    }
  }
}
