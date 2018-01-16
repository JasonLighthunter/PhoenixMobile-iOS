import UIKit
import PhoenixKitsuCore

struct KeychainConfiguration {
  static let serviceName = "PhoenixMobile"
  static let accessGroup: String? = nil
}

class LoginViewController: UIViewController {
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
  
  let createLoginButtonTag = 0
  let loginButtonTag = 1
  
  let decoder = JSONDecoder()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginErrorAlert.addAction(okAction)
    deleteAccountError.addAction(okAction)
    
    titleLabel.text = "Login"
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
    
    
    AuthenticationUtility.getToken(with: accountName, and: password) { responseData, error in
      do {
        let tokenResponse = try self.decoder.decode(TokenResponse.self, from: responseData!)
        AuthenticationUtility.setAccessToken(tokenResponse.accessToken)
        
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: accountName,
                                                accessGroup: KeychainConfiguration.accessGroup)
        do {
          // This is a new account, create a new keychain item with the account name.
          try passwordItem.savePassword(tokenResponse.refreshToken)
        } catch {
          fatalError("Error updating keychain - \(error)")
        }
      } catch {
        print(error.localizedDescription)
      }
      
      UserDefaults.standard.set(true, forKey: "hasLoginKey")
      
      self.dismiss(animated: true)
    }
  }
  
  private func getAccountName() -> String? {
    return UserDefaults.standard.value(forKey: "username") as? String
  }
  
  private func setAccountName(_ accountName: String) {
    UserDefaults.standard.setValue(accountName, forKey: "username")
  }
  
  @IBAction func deleteButtonClicked(_ sender: Any) {
    guard let accountName = getAccountName() else {
      present(loginErrorAlert, animated: true)
      return
    }
    
    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                            account: accountName,
                                            accessGroup: KeychainConfiguration.accessGroup)
    do {
      try passwordItem.deleteItem()
    } catch {
      present(loginErrorAlert, animated: true)
    }
    UserDefaults.standard.removeObject(forKey: "username")
    self.dismiss(animated: true)
  }
}
