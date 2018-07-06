import UIKit
import PhoenixKitsuMedia
import Requestable

class PhoenixDetailViewController<T: HasMediaObjectAttributes & Requestable>: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!

  private var imageFetcher: ImageFetcher!

  var mediaItem: T!
  
  override func viewDidLoad() {
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)
    
    self.setTitle()
    synopsisLabel.text = mediaItem?.attributes?.synopsis

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    if let requestURL = mediaItem?.attributes?.posterImage?.small {
      imageFetcher.getImageFrom(requestURL, callback: imageCallback)
    } else {
      posterImageView.image = nil
    }
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

extension PhoenixDetailViewController : HasImageFetcher {
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
}
