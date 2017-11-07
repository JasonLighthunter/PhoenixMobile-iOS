//
//  NetworkingUtil.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 25/10/2017.
//  Copyright © 2017 Job Cuppen. All rights reserved.

import Foundation

class NetworkingUtil {
  static let networkingUtilSyncQueue = DispatchQueue(label: "nl.jobcuppen.phoenixMobile.NetworkingUtil")

  class func getAccessToken(withUsername username: String, password: String, clientID: String,
                            andClientSecret clientSecret: String, callback: @escaping (Data?) -> Bool) {
    networkingUtilSyncQueue.async {
      var request = URLRequest(url: URL(string: "https://kitsu.io/api/oauth/token")!)

      request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      request.addValue(clientID, forHTTPHeaderField: "client_id")
      request.addValue(clientSecret, forHTTPHeaderField: "client_secret")

      let params = [
        "grant_type": "password",
        "username": username,
        "password": password
      ]

      request.httpBody = try? JSONSerialization.data(withJSONObject: params)
      request.httpMethod = "POST"

      let task = URLSession.shared.dataTask(with: request) { responseData, _, _ in
        let _ = callback(responseData)
      }
      task.resume()
    }
  }
}
