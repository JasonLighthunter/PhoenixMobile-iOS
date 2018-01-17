import UIKit
import PhoenixKitsuCore

class ProfileViewController: UIViewController, HasKitsuHandler {
  @IBOutlet weak var profileLabel: UILabel!
  
  private var kitsuHandler: KitsuHandler!
  
  func setKitsuHandler(_ handler: KitsuHandler) {
    self.kitsuHandler = handler
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showLoginView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showLoginView()
  }
  
  func showLoginView() {
    
    if !(AuthenticationUtility.isAuthenticated) {
      
      performSegue(withIdentifier: "loginView", sender: self)
    } else {
      profileLabel.text = "you are now logged in"
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let loginController = segue.destination as? LoginViewController {
      loginController.setKitsuHandler(kitsuHandler)
    }
  }
}
