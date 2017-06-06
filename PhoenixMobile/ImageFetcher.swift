//
//  ImageFetcher.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 22/03/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import UIKit

class ImageFetcher {
  static let imageFetcherSyncQueue = DispatchQueue(label: "nl.phoenixMobile.imageFetcher")

  class func getFrom(_ url: URL, callback: @escaping (UIImage?, Error?) -> Void) {
    imageFetcherSyncQueue.async {
      let request = NSMutableURLRequest(url: url)

      request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
      request.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")

      request.httpMethod = "GET";

      let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
        var image: UIImage?

        if let data = data {
          image = UIImage(data: data)
        }
        callback(image, error)
      }
      task.resume()
    }
  }
}
