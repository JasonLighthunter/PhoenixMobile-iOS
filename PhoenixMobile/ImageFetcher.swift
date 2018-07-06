import UIKit
import Foundation

class ImageFetcher {
  private let session: URLSession
  private var dataTask: URLSessionDataTask?
  
  init(session: URLSession? = nil) {
    self.session = session ?? URLSession(configuration: .default)
  }
  
  func getImageFrom(_ urlString: String, callback: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else { return callback(nil) }
    let request = URLRequest(url: url)
    
    let innerCallback: (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void = { data, response, error in
      guard error == nil else { return callback(nil) }
      let image = UIImage(data: data!)
      callback(image)
    }
    
    dataTask?.cancel()
    dataTask = session.dataTask(with: request, completionHandler: innerCallback)
    dataTask?.resume()
  }
}

