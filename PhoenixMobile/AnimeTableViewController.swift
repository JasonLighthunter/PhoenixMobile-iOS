//
//  TableViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 10/03/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit
import PhoenixCoreSwift

class AnimeTableViewController: PhoenixTableViewController {
  private let dataType = Anime.self
  private var items: [Anime] = []
  let filters = ["text": "rwby"]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Anime"
    
    do {
      try PhoenixCore.getCollection(ofType: dataType, withFilters: filters) { searchResult in
        if let result = searchResult {
          DispatchQueue.main.async {
            self.items.append(contentsOf: result.data)
            super.addResultToItems(result)
          }
        }
      }
    } catch PhoenixError.invalidURL(let reason, _){
      print(reason)
    } catch {
      print(error.localizedDescription)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? AnimeDetailViewController {
      detailcontroller.mediaItem = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

    let anime = items[indexPath.row]

    let titleLanguageEnum = getTitleLanguageEnum()

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
          self.handleResult(searchResult)
        }
      } catch {
        print(error.localizedDescription) //TODO: handle error
      }
    }
  }

  private func handleResult(_ searchResult: KitsuSearchResult<Anime>?) {
    if let result = searchResult {
      DispatchQueue.main.async {
        self.items.append(contentsOf: result.data)
        super.addResultToItems(result)
      }
    }
  }
}
