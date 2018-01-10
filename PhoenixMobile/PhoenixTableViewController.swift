import UIKit
import PhoenixKitsuCore
import PhoenixKitsuMedia

class PhoenixTableViewController<T : KitsuMediaObject>: UITableViewController {
  internal var filters: [String : String] = [:]
  internal var items: [T] = []
  internal var latestNextLink: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    let nc = NotificationCenter.default
    _ = nc.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    do {
      try PhoenixCore.getCollection(withFilters: filters) { (searchResult: SearchResult<T>?) in
        if let result = searchResult {
          DispatchQueue.main.async {
            self.items.append(contentsOf: result.data ?? [])
            self.addResultToItems(result)
          }
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? PhoenixDetailViewController<T> {
      detailcontroller.mediaItem = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  private func catchNotification(notification: Notification) {
    self.tableView.reloadData()
  }

  internal func addResultToItems(_ result: SearchResult<T>) {
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
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    
    let item = items[indexPath.row]
    
    let titleLanguageEnum = getTitleLanguageEnum()
    
    cell.textLabel?.text = item.getTitleWith(identifier: titleLanguageEnum)
    cell.detailTextLabel?.text = item.attributes?.slug
    
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
        try PhoenixCore.getCollection(byURL: next) { (searchResult : SearchResult<T>?) in
          if let result = searchResult {
            DispatchQueue.main.async {
              //if(result.data == nil) { print(next);}
              self.items.append(contentsOf: result.data ?? [])
              self.addResultToItems(result)
            }
          }
        }
      } catch {
        print(error.localizedDescription) //TODO: handle error
      }
    }
  }
}
