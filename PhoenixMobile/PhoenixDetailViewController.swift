//
//  PhoenixDetailViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 09/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.
//

import Foundation

import UIKit
import PhoenixCoreSwift

class PhoenixDetailViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!

  let displayLanguagePreferenceKey = "display_language_preference"
  
  var mediaItem: KitsuMediaObject?

  override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = false
    }

    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    setTitleLabel()
  }

  internal func setTitleLabel() {
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: displayLanguagePreferenceKey) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }

    titleLabel.text = mediaItem?.getTitleWith(identifier: titleLanguageEnum)
  }

  internal func catchNotification(notification: Notification) {
    setTitleLabel()
  }

  internal func fetchImage(fromURLString urlString: String) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    ImageFetcher.getFrom(URL(string: urlString)!) { imageResult in
      self.handleImageResult(imageResult)
    }
  }

  private func handleImageResult(_ imageResult: UIImage?) {
    if let image = imageResult {
      DispatchQueue.main.async {
        self.posterImageView.image = image
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
}
