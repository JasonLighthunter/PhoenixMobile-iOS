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
}
