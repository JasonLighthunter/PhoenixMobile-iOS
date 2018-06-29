import UIKit
import PhoenixKitsuCore
import PhoenixKitsuUsers

struct KeychainConfiguration {
  static let serviceName = "PhoenixMobile"
  static let accessGroup: String? = nil
}

class LoginViewController: UIViewController, HasKitsuHandler, HasAuthenticationUtility {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  let loginErrorAlert = UIAlertController(title: "Unable to login",
                                          message: "Wrong username or password.",
                                          preferredStyle: .alert)
  let okAction = UIAlertAction(title: "OK", style: .default)
  
  let deleteAccountError = UIAlertController(title: "Unable to delete account",
                                             message: "No account with that username",
                                             preferredStyle: .alert)
  
  private var kitsuHandler: KitsuHandler!
  private var authenticationUtility: AuthenticationUtility!
  
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
  func setAuthenticationUtility(_ authenticationUtility: AuthenticationUtility) {
    self.authenticationUtility = authenticationUtility
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginErrorAlert.addAction(okAction)
    deleteAccountError.addAction(okAction)
    
    titleLabel.text = "Login"
  }
  
  private func handleUserResponse(_ searchResult: SearchResult<User>?) {
    if let result = searchResult, let user = result.data.first {
      authenticationUtility.set(loggedInUser: user)
      self.dismiss(animated: true)
    } else {
      present(loginErrorAlert, animated: true)
    }
  }
  
  private func handleTokenResponse(_ response: TokenResponse?) {
    let userDefaultsUsername = UserDefaults.standard.value(forKey: "username") as? String
    
    guard let tokenResponse = response, let accountName = userDefaultsUsername else {
      return self.present(self.loginErrorAlert, animated: true)
    }
    
    authenticationUtility.set(accessToken: tokenResponse.accessToken)
    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                             account: accountName,
                                             accessGroup: KeychainConfiguration.accessGroup)
    do {
      try passwordItem.savePassword(tokenResponse.refreshToken)
    } catch {
      fatalError("Error updating keychain - \(error)")
    }
    
    let filter = ["self" : "true"]
    let accessToken = authenticationUtility.accessToken
    kitsuHandler.getCollection(by: filter, accessToken: accessToken, callback: handleUserResponse)
  }
  
  @IBAction func loginClicked(_ sender: AnyObject) {
    guard
      let accountName = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
      let password = passwordField.text,
      !accountName.isEmpty && !password.isEmpty else {
        present(loginErrorAlert, animated: true)
        return
    }
    
    usernameField.resignFirstResponder()
    passwordField.resignFirstResponder()
    
    setAccountName(accountName)
    kitsuHandler.getAccessToken(with: accountName, and: password, callback: handleTokenResponse)
  }
  
  private func getAccountName() -> String? {
    return UserDefaults.standard.value(forKey: "username") as? String
  }
  
  private func setAccountName(_ accountName: String) {
    UserDefaults.standard.setValue(accountName, forKey: "username")
  }
  
  @IBAction func dismissButtonClicked(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
//  @IBAction func deleteButtonClicked(_ sender: Any) {
//    guard let accountName = getAccountName() else {
//      present(loginErrorAlert, animated: true)
//      return
//    }
//
//    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
//                                            account: accountName,
//                                            accessGroup: KeychainConfiguration.accessGroup)
//    do {
//      try passwordItem.deleteItem()
//    } catch {
//      present(loginErrorAlert, animated: true)
//    }
//    UserDefaults.standard.removeObject(forKey: "username")
//    self.dismiss(animated: true)
//  }
}
