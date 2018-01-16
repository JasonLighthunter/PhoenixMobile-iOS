import Alamofire
import PhoenixKitsuCore
import Foundation

class AuthenticationUtility {
  static private(set) var accessToken: String?
  static var isAuthenticated: Bool {
    get {
      return accessToken != nil
    }
  }
  
  static func setAccessToken(_ accessToken: String?) {
    self.accessToken = accessToken
  }
  
  class func refreshToken(with refreshToken: String, _ callback: @escaping (Data?, Error?) -> ()) {
    let url = "https://kitsu.io/api/oauth/token"
    
    let parameters: Parameters = [
      "grant_type" : "refresh_token",
      "refresh_token" : refreshToken
    ]
    
    let headers: HTTPHeaders = [
      "CLIENT_ID": "dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd",
      "CLIENT_SECRET": "54d7307928f63414defd96399fc31ba847961ceaecef3a5fd93144e960c0e151"
    ]
    
    Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, headers: headers)
      .responseData { response in
        switch response.result {
        case .failure(let error): callback(nil, error)
        case .success:callback(response.result.value, nil)
        }
    }
  }
  
  class func getToken(with username: String, and password: String,
                      _ callback: @escaping (Data?, Error?) -> ()) {
    //TODO: replace with constants
    let url = "https://kitsu.io/api/oauth/token"
    
    let parameters: Parameters = [
      "grant_type" : "password",
      "username" : username,
      "password" : password
    ]
    
    let headers: HTTPHeaders = [
      "CLIENT_ID": "dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd",
      "CLIENT_SECRET": "54d7307928f63414defd96399fc31ba847961ceaecef3a5fd93144e960c0e151"
    ]
    
    Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, headers: headers)
      .responseData { response in
        switch response.result {
        case .failure(let error): callback(nil, error)
        case .success:callback(response.data, nil)
        }
    }
  }
}
