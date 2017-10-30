//
//  UserViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 11/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit

class UserViewController: UIViewController {
  var isAuthenticated = false

  @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {}

  override func viewDidLoad() {
    super.viewDidLoad()
    showLoginView()
  }

  func showLoginView() {
    if !isAuthenticated {
      performSegue(withIdentifier: "loginView", sender: self)
    }
  }
}
