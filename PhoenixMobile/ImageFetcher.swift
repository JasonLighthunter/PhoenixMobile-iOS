import UIKit
import PhoenixKitsuCore

class ImageFetcher {
  func getImageFrom(_ url: URL, callback: @escaping (UIImage?) -> Void) {
    NetworkingUtility().getDataFrom(url.absoluteString) { response, error in
      guard let data = response else { return callback(nil) }
      
      let image = UIImage(data: data)
      callback(image)
    }
  }
}

