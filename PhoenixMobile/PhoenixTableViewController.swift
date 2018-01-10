import UIKit
import PhoenixCoreSwift
import PhoenixKitsuCore
import PhoenixKitsuMedia

class PhoenixTableViewController<T : KitsuObject>: UITableViewController {
  internal var items: [T] = []

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
