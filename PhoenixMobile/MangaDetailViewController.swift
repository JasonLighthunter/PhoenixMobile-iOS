//
//  MangaDetailViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 05/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.
//

import UIKit
import PhoenixCoreSwift

class MangaDetailViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!

  var manga: Manga?

  override func viewDidLoad() {
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }

    titleLabel.text = manga?.getTitleWith(identifier: titleLanguageEnum)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    ImageFetcher.getFrom(URL(string: (manga?.attributes?.posterImage?.small)!)!) { imageResult, _ in
      if let image = imageResult {
        DispatchQueue.main.async {
          self.posterImageView.image = image
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      }
    }

    synopsisLabel.text = manga?.attributes?.synopsis
  }

  private func catchNotification(notification: Notification) {
    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }

    titleLabel.text = manga?.getTitleWith(identifier: titleLanguageEnum)
  }
}
