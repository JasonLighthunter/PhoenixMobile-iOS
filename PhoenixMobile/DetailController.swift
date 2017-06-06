//
//  DetailController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 14/02/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit
import PhoenixCoreSwift

class DetailController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!

  var anime: Anime?

  override func viewDidLoad() {
    let nc = NotificationCenter.default
    nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(titleLanguage)
    }

    titleLabel.text = self.anime?.getTitleWith(identifier: titleLanguageEnum)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    ImageFetcher.getFrom(URL(string: (self.anime!.attributes?.posterImage?.small)!)!) { imageResult, error in
      if let image = imageResult {
        DispatchQueue.main.async {
          self.posterImageView.image = image
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      }
    }

    synopsisLabel.text = self.anime?.attributes?.synopsis
  }

  private func catchNotification(notification: Notification) {
    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(titleLanguage)
    }

    titleLabel.text = self.anime?.getTitleWith(identifier: titleLanguageEnum)
  }
}
