import UIKit
import PhoenixKitsuMedia
import Requestable

class PhoenixDetailViewController<T: HasMediaObjectAttributes & Requestable>: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!

  var mediaItem: T?
  
  override func viewDidLoad() {
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)
    
    self.setTitle()
    
    let attributes = mediaItem?.attributes
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    ImageFetcher.getFrom(URL(string: (attributes?.posterImage?.small)!)!) { imageResult in
      if let image = imageResult {
        DispatchQueue.main.async {
          self.posterImageView.image = image
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      }
    }
    
    synopsisLabel.text = attributes?.synopsis
  }
  
  internal func catchNotification(notification: Notification) {
    self.setTitle()
  }
  
  private func setTitle() {
    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical
    
    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }
    
    titleLabel.text = mediaItem?.getTitleWith(identifier: titleLanguageEnum)
  }
}
