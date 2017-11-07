//
//  MangaDetailViewController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 05/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import PhoenixCoreSwift

class MangaDetailViewController: PhoenixDetailViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let attributes = (self.mediaItem as? Manga)?.attributes
    if let imageURLString = attributes?.posterImage?.small {
      fetchImage(fromURLString: imageURLString)
    } //TODO: PlaceholderImage

    synopsisLabel.text = attributes?.synopsis
  }
}
