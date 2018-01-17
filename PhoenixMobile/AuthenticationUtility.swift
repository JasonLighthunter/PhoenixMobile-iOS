import PhoenixKitsuCore
import PhoenixKitsuUsers

class AuthenticationUtility {
  static private(set) var accessToken: String?
  static private(set) var loggedInUser: User?
  
  static var isAuthenticated: Bool {
    get {
      return accessToken != nil && loggedInUser != nil
    }
  }
  
  static func set(accessToken: String?) {
    self.accessToken = accessToken
  }
  static func set(loggedInUser: User?) {
    self.loggedInUser = loggedInUser
  }
  
  static func logout() {
    accessToken = nil
    loggedInUser = nil
  }
}
