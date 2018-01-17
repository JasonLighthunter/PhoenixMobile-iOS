import UIKit
import PhoenixKitsuCore
import PhoenixKitsuMedia
import Requestable

class PhoenixMediaItemTableViewController<T: HasMediaObjectAttributes & Requestable> :
PhoenixItemTableViewController<T> {
  private func callback(_ searchResult: SearchResult<T>?) {
    if let result = searchResult {
      DispatchQueue.main.async {
        self.items.append(contentsOf: result.data ?? [])
        self.addResultToItems(result)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    kitsuHandler.getCollection(by: filters, callback: self.callback);
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? PhoenixDetailViewController<T> {
      detailcontroller.setImageFetcher(self.imageFetcher)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier!, for: indexPath)
    
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
    
    if offsetY > contentHeight - frameHeight, doingRequest == false, let nextURL = latestNextLink {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      //only prevents adding to list not firing request.
      kitsuHandler.getCollection(by: nextURL, callback: self.callback);
    }
  }
}
