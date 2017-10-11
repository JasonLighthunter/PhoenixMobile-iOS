//
//  PhoenixDetailView.swift
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
//
  var mediaItem: KitsuMediaObject?
//
//  override func viewDidLoad() {
//    let nc = NotificationCenter.default
//    _ = nc.addObserver(forName:UserDefaults.didChangeNotification, object: nil, queue: nil, using: catchNotification)
//
//    let key = "display_language_preference"
//    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical
//
//    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
//      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
//    }
//
//    titleLabel.text = item?.getTitleWith(identifier: titleLanguageEnum)
//
//    UIApplication.shared.isNetworkActivityIndicatorVisible = true
//
//    ImageFetcher.getFrom(URL(string: (item?.attributes?.posterImage?.small)!)!) { imageResult, _ in
//      if let image = imageResult {
//        DispatchQueue.main.async {
//          self.posterImageView.image = image
//          UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//      }
//    }
//
//    synopsisLabel.text = item?.attributes?.synopsis
//  }

  internal func catchNotification(notification: Notification) {
    let key = "display_language_preference"
    var titleLanguageEnum: TitleLanguageIdentifierEnum = TitleLanguageIdentifierEnum.canonical

    if let titleLanguage: String = UserDefaults.standard.string(forKey: key) {
      titleLanguageEnum = TitleLanguageIdentifierEnum(rawValue: titleLanguage)!
    }

    titleLabel.text = mediaItem?.getTitleWith(identifier: titleLanguageEnum)
  }

  internal func fetchImage(fromURLString urlString: String) {
    ImageFetcher.getFrom(URL(string: urlString)!) { imageResult in
      if let image = imageResult {
        DispatchQueue.main.async {
          self.posterImageView.image = image
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
      }
    }
  }
}
