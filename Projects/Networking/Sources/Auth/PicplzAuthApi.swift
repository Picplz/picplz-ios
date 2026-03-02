//
//  PicplzAuthApi.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Common
import Foundation
import Moya

public enum PicplzAuthApi {
  case signInKakao(SignInDTO)
}

extension PicplzAuthApi: TargetType {
  public var baseURL: URL {
    if let baseURLRaw = BundleInfos.baseURL.value,
       let baseURL = URL(string: baseURLRaw) {
        return baseURL
    } else {
      PicplzAuthApi.logger.error("BaseURL이 올바르지 않습니다.")
      fatalError("BaseURL이 올바르지 않습니다.")
    }
  }
  
  public var path: String {
    switch self {
    case .signInKakao:
      return "/v1/auth/kakao"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .signInKakao:
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case let .signInKakao(dto):
      return .requestJSONEncodable(dto)
    }
  }
  
  public var headers: [String : String]? {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return ["Client": "picplz-ios-v\(version ?? "unknown")"]
  }
  
  static var logger: PicLogger {
    PicLogger(category: "PicplzAuthApi")
  }
}
