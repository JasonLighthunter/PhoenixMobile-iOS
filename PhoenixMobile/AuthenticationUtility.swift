import PhoenixKitsuUsers
import Foundation

class AuthenticationUtility {
  private(set) var accessToken: String?
  private(set) var loggedInUser: User?
  
  var isAuthenticated: Bool {
    get {
      return accessToken != nil && loggedInUser != nil
    }
  }
  
  func set(accessToken: String?) {
    self.accessToken = accessToken
  }
  func set(loggedInUser: User?) {
    self.loggedInUser = loggedInUser
  }
  
  func logout() {
    accessToken = nil
    loggedInUser = nil
  }
}
