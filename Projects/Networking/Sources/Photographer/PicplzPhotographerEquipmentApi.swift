//
//  PicplzPhotographerEquipmentApi.swift
//  Networking
//
//  Created by 임영택 on 3/17/26.
//

import Common
import Foundation
import Moya

public enum PicplzPhotographerEquipmentApi {
  case getDefaultEquipments
}

extension PicplzPhotographerEquipmentApi: TargetType, AccessTokenAuthorizable {
  public var baseURL: URL {
    if let baseURLRaw = BundleInfos.baseURL.value,
       let baseURL = URL(string: baseURLRaw) {
        return baseURL
    } else {
      PicplzPhotographerEquipmentApi.logger.error("BaseURL이 올바르지 않습니다.")
      fatalError("BaseURL이 올바르지 않습니다.")
    }
  }
  
  public var path: String {
    switch self {
    case .getDefaultEquipments:
      return "/v1/cameras"
    }
  }
  
  public var method: Moya.Method {
    return .get
  }
  
  public var task: Moya.Task {
    switch self {
    case .getDefaultEquipments:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return ["Client": "picplz-ios-v\(version ?? "unknown")"]
  }
  
  public var authorizationType: AuthorizationType? {
    return .bearer
  }
  
  static var logger: PicLogger {
    PicLogger(category: "PicplzPhotographerEquipmentApi")
  }
}
