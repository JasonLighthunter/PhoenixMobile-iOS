//
//  MangaDetailViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 05/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.
//

import UIKit
import PhoenixCoreSwift

class MangaDetailViewController: PhoenixDetailViewController {
  override func viewDidLoad() {
    let nc = NotificationCenter.default
    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)

    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }

    titleLabel.text = mediaItem?.getTitleWith(identifier: titleLanguageEnum)

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    let attributes = (self.mediaItem as? Manga)?.attributes
    if let imageURLString = attributes?.posterImage?.small {
      fetchImage(fromURLString: imageURLString)
    } //TODO: PlaceholderImage

    synopsisLabel.text = attributes?.synopsis
  }
}
