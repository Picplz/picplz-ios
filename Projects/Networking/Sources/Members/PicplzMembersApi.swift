//
//  PicplzMembersApi.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Common
import Foundation
import Moya

public enum PicplzMembersApi {
  case checkDuplicatedNickname(String)
}

extension PicplzMembersApi: TargetType {
  public var baseURL: URL {
    if let baseURLRaw = BundleInfos.baseURL.value,
       let baseURL = URL(string: baseURLRaw) {
        return baseURL
    } else {
      PicplzMembersApi.logger.error("BaseURL이 올바르지 않습니다.")
      fatalError("BaseURL이 올바르지 않습니다.")
    }
  }
  
  public var path: String {
    switch self {
    case .checkDuplicatedNickname:
      return "/v1/members/nickname"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .checkDuplicatedNickname:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case let .checkDuplicatedNickname(nickname):
      return .requestParameters(parameters: [nickname: nickname], encoding: URLEncoding.queryString)
    }
  }
  
  public var headers: [String : String]? {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return ["Client": "picplz-ios-v\(version ?? "unknown")"]
  }
  
  static var logger: PicLogger {
    PicLogger(category: "PicplzMembersApi")
  }
}
