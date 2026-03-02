//
//  PicplzTokens.swift
//  Domain
//
//  Created by 임영택 on 2/27/26.
//

import Foundation

public typealias KakaoAccessToken = String
public typealias PicplzAuthToken = String

public struct PicplzTokens {
  public let accessToken: PicplzAuthToken
  public let refreshToken: PicplzAuthToken

  public init(accessToken: PicplzAuthToken, refreshToken: PicplzAuthToken) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }

  // MARK: - Computed Properties

  /// 유저 식별자
  public var userId: String? {
    return decodePayload(from: accessToken)?["sub"] as? String
  }

  /// 권한
  public var role: String? {
    return decodePayload(from: accessToken)?["auth"] as? String
  }
}

extension PicplzTokens {
  // MARK: - Private Methods

  /// JWT 토큰의 Payload를 Dictionary로 디코딩
  private func decodePayload(from token: PicplzAuthToken) -> [String: Any]? {
    let segments = token.components(separatedBy: ".")
    guard segments.count > 1 else { return nil }
    let payloadSegment = segments[1]

    // Base64Url 형식을 Base64 형식으로 보정 (패딩 및 문자 치환)
    var base64 =
      payloadSegment
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")

    let length = Double(base64.lengthOfBytes(using: .utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = Int(requiredLength - length)

    if paddingLength > 0 {
      let padding = String(repeating: "=", count: paddingLength)
      base64 += padding
    }

    // 데이터 변환 및 JSON 파싱
    guard
      let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    else { return nil }

    return try? JSONSerialization.jsonObject(with: data, options: [])
      as? [String: Any]
  }
}
