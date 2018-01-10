import UIKit
import Alamofire

class ImageFetcher {
  static let imageFetcherSyncQueue = DispatchQueue(label: "nl.phoenixMobile.imageFetcher")

  class func getFrom(_ url: URL, callback: @escaping (UIImage?) -> Void) {
    Alamofire.request(url.absoluteString).responseData { response in
      guard let data = response.result.value else { return callback(nil) }
      
      let image = UIImage(data: data)
      callback(image)
    }
  }
}
