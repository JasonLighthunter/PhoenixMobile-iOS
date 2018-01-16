import UIKit

class ProfileViewController: UIViewController {  
  @IBOutlet weak var profileLabel: UILabel!
  
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
}
