import UIKit
import PhoenixKitsuCore
import PhoenixKitsuUsers

enum LoginBarItemStatus: String {
  case login = "Log In"
  case logout = "Log Out"
}

class ProfileViewController: UIViewController {
  @IBOutlet weak var profileLabel: UILabel!
  
  private var kitsuHandler: KitsuHandler!
  private var authenticationUtility: AuthenticationUtility!
  
  private var loginBarItemStatus: LoginBarItemStatus {
    get { return authenticationUtility.isAuthenticated ? .logout : .login }
  }
  
  private var user : User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showProfileInfo()
  }
  
  @IBAction func LoginBarItemClicked(_ sender: Any) {
    if loginBarItemStatus == .login {
      performSegue(withIdentifier: "loginView", sender: self)
    } else {
      authenticationUtility.logout()
    }
  }
  
  func showProfileInfo() {
    if authenticationUtility.isAuthenticated,
      let user = authenticationUtility.loggedInUser,
      let userAttributes = user.attributes
    {
      self.user = user
      profileLabel.text = "Welcome back, " + (userAttributes.name ?? "mysterious stranger")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let loginController = segue.destination as? LoginViewController {
      loginController.setKitsuHandler(kitsuHandler)
      loginController.setAuthenticationUtility(authenticationUtility)
    }
  }
}

extension ProfileViewController: HasKitsuHandler {
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
}

extension ProfileViewController: HasAuthenticationUtility {
  func setAuthenticationUtility(_ authenticationUtility: AuthenticationUtility) {
    self.authenticationUtility = authenticationUtility
  }
}
