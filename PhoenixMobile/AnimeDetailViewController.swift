//
//  DetailController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 14/02/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit
import PhoenixCoreSwift

class AnimeDetailViewController: PhoenixDetailViewController {
  override func viewDidLoad() {
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }

    titleLabel.text = mediaItem?.getTitleWith(identifier: titleLanguageEnum)

    let attributes = (self.mediaItem as? Anime)?.attributes

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    ImageFetcher.getFrom(URL(string: (attributes?.posterImage?.small)!)!) { imageResult in
      if let image = imageResult {
        DispatchQueue.main.async {
          self.posterImageView.image = image
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      }
    }

    synopsisLabel.text = attributes?.synopsis
  }
}
