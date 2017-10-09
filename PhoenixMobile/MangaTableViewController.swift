//
//  MangaTableViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 20/06/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit
import PhoenixCoreSwift

class MangaTableViewController: PhoenixTableViewController {
  private let dataType = Manga.self
  private var items: [Manga] = []
  let filters = ["text": "titan"]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Manga"

    do {
      try PhoenixCore.getCollection(ofType: dataType.self, withFilters: filters) { searchResult in
        if let result = searchResult {
          DispatchQueue.main.async {
            self.items.append(contentsOf: result.data)
            super.addResultToItems(result)
          }
        }
      }
    } catch PhoenixError.invalidURL(let reason, _){
      print(reason) //TODO: handle error
    } catch {
      print(error.localizedDescription)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? MangaDetailViewController {
      detailcontroller.mediaItem = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MangaCell", for: indexPath)

    let manga = items[indexPath.row]

    let titleLanguageEnum = getTitleLanguageEnum()

    cell.textLabel?.text = manga.getTitleWith(identifier: titleLanguageEnum)
    cell.detailTextLabel?.text = manga.attributes?.slug

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
              self.items.append(contentsOf: result.data)
              super.addResultToItems(result)
            }
          }
        }
      } catch {
        print(error.localizedDescription) //TODO: handle error
      }
    }
  }
}
