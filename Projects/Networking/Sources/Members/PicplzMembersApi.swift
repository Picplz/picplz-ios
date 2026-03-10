//
//  PicplzMembersApi.swift
//  Networking
//
//  Created by 임영택 on 2/27/26.
//

import Common
import Domain
import Foundation
import Moya

public enum PicplzMembersApi {
  case checkDuplicatedNickname(String)
  case getMemberInfo(Int)
  case createCustomer(CreateCustomerRequestDTO)
}

extension PicplzMembersApi: TargetType, AccessTokenAuthorizable {
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
    case let .getMemberInfo(memberId):
      return "/v1/members/\(memberId)/info"
    case let .createCustomer(registerRequest):
      return "/v1/customers"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .checkDuplicatedNickname:
      return .get
    case .getMemberInfo:
      return .get
    case .createCustomer:
      return .post
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case let .checkDuplicatedNickname(nickname):
      return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
    case .getMemberInfo:
      return .requestPlain
    case let .createCustomer(dto):
      return .requestJSONEncodable(dto)
    }
  }
  
  public var headers: [String : String]? {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return ["Client": "picplz-ios-v\(version ?? "unknown")"]
  }
  
  public var authorizationType: AuthorizationType? {
    switch self {
    case .checkDuplicatedNickname:
      return .none
    default:
      return .bearer
    }
  }
  
  static var logger: PicLogger {
    PicLogger(category: "PicplzMembersApi")
  }
}
