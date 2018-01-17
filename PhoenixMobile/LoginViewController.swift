import UIKit
import PhoenixKitsuCore

struct KeychainConfiguration {
  static let serviceName = "PhoenixMobile"
  static let accessGroup: String? = nil
}

class LoginViewController: UIViewController, HasKitsuHandler {
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
  
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginErrorAlert.addAction(okAction)
    deleteAccountError.addAction(okAction)
    
    titleLabel.text = "Login"
  }
  
  private func handleTokenResponse(_ response: TokenResponse?) {
    guard let tokenResponse = response, let accountName = getAccountName() else {
      return self.present(self.loginErrorAlert, animated: true)
    }
    
    AuthenticationUtility.set(accessToken: tokenResponse.accessToken)
    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                            account: accountName,
                                            accessGroup: KeychainConfiguration.accessGroup)
    do {
      try passwordItem.savePassword(tokenResponse.refreshToken)
    } catch {
      fatalError("Error updating keychain - \(error)")
    }
    self.dismiss(animated: true)
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
    
    kitsuHandler.getTokenResponse(with: accountName, and: password, callback: handleTokenResponse)
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
