//
//  TokenRequestResult.swift
//  PhoenixMobile
//
//  Created by Job Cuppen on 25/10/2017.

import Foundation

public class TokenRequestResult: Decodable {
  public let accessToken: String
  public let tokenType: String
  public let expiresIn: Int
  public let refreshToken: String
  public let scope: String
  public let createdAt: Int

  private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case expiresIn = "expires_in"
    case refreshToken = "refresh_token"
    case scope
    case createdAt = "created_at"
  }
}

