import UIKit

class ImageFetcher {
  static let imageFetcherSyncQueue = DispatchQueue(label: "nl.phoenixMobile.imageFetcher")

  class func getFrom(_ url: URL, callback: @escaping (UIImage?) -> Void) {
    imageFetcherSyncQueue.async {
      let request = NSMutableURLRequest(url: url)

      request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
      request.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")

      request.httpMethod = "GET"

      let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
        guard let data = data else { return callback(nil) }

        let image = UIImage(data: data)
        callback(image)
      }
      task.resume()
    }
  }
}
