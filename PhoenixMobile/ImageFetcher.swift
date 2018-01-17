import UIKit
import Alamofire

class ImageFetcher {
  private func handle(response: DataResponse<Data>, _ callback: (Data?, Error?) -> Void) {
    switch response.result {
    case .failure(let error): callback(nil, error)
    case .success: callback(response.result.value, nil)
    }
  }
  
  func getImageFrom(_ url: String, callback: @escaping (UIImage?) -> Void) {
    let innerCallback: (_ data: Data?, _ error: Error?) -> Void = { data, error in
      guard error == nil else { return callback(nil) }
      guard let image = UIImage(data: data!) else { return callback(nil) }
      
      callback(image)
    }
    
    Alamofire.request(url).responseData { response in
      self.handle(response: response, innerCallback)
    }
  }
}

