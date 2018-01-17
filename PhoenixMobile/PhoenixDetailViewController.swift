import UIKit
import PhoenixKitsuMedia
import Requestable

class PhoenixDetailViewController<T: HasMediaObjectAttributes & Requestable>: UIViewController, HasImageFetcher {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!

  var mediaItem: T!
  private var imageFetcher: ImageFetcher!
  
  func setImageFetcher(_ imageFetcher: ImageFetcher) {
    self.imageFetcher = imageFetcher
  }
  
  func imageCallback(_ imageResult: UIImage?) {
    if let image = imageResult {
      DispatchQueue.main.async {
        self.posterImageView.image = image
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
  
  override func viewDidLoad() {
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)
    
    self.setTitle()
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    let requestURL = URL(string: (mediaItem?.attributes?.posterImage?.small!)!)
    imageFetcher.getImageFrom(requestURL!, callback: imageCallback)
    
    synopsisLabel.text = mediaItem?.attributes?.synopsis
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
