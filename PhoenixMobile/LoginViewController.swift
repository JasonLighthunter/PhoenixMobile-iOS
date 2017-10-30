//
//  LoginViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 11/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit

class LoginViewController: UIViewController {
  let usernameKey = "batman"
  let passwordKey = "bruce"

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func loginAction(_ sender: AnyObject) {
    if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!) {
      performSegue(withIdentifier: "dismissLogin", sender: self)
    }
  }

  func checkLogin(username: String, password: String) -> Bool {
    let clientID = "dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd"
    let secret = "54d7307928f63414defd96399fc31ba847961ceaecef3a5fd93144e960c0e151"

    NetworkingUtil.getAccessToken(withUsername: username, password: password, clientID: clientID,
                                  andClientSecret: secret) { (data) -> Bool in
      guard let tokenData = data else { return false }
                                  let json = try? JSONSerialization.jsonObject(with: tokenData)
                                    dump(json)
      let tokenResult = try? JSONDecoder().decode(TokenRequestResult.self, from: tokenData)
      print(tokenResult?.tokenType ?? "Default")
      return true
    }
    return false
  }
}
