//
//  DetailController.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 14/02/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import PhoenixCoreSwift

class AnimeDetailViewController: PhoenixDetailViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let attributes = (self.mediaItem as? Anime)?.attributes
    if let imageURLString = attributes?.posterImage?.small {
      fetchImage(fromURLString: imageURLString)
    } //TODO: PlaceholderImage

    synopsisLabel.text = attributes?.synopsis
  }
}
