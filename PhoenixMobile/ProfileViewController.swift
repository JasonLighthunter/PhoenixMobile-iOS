import UIKit
import PhoenixKitsuCore
import PhoenixKitsuUsers

enum LoginBarItemStatus: String {
  case login = "Log In"
  case logout = "Log Out"
}

class ProfileViewController: UIViewController, HasKitsuHandler {
  @IBOutlet weak var profileLabel: UILabel!
  
  private var loginBarItemStatus: LoginBarItemStatus {
    get {
      return AuthenticationUtility.isAuthenticated ? .logout : .login
    }
  }
  
  private var user : User?
  
  private var kitsuHandler: KitsuHandler!
  
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    showLoginView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    showLoginView()
  }
  
  @IBAction func LoginBarItemClicked(_ sender: Any) {
    if loginBarItemStatus == .login {
      performSegue(withIdentifier: "loginView", sender: self)
    } else {
      AuthenticationUtility.logout()
    }
  }
  
  func showProfileInfo() {
    if AuthenticationUtility.isAuthenticated,
      let user = AuthenticationUtility.loggedInUser,
      let userAttributes = user.attributes
    {
      self.user = user
      profileLabel.text = "Welcome back, " + (userAttributes.name ?? "mysterious stranger")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let loginController = segue.destination as? LoginViewController {
      loginController.setKitsuHandler(kitsuHandler)
    }
  }
}
