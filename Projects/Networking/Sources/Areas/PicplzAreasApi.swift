//
//  PicplzAreasApi.swift
//  Networking
//
//  Created by 임영택 on 3/15/26.
//

import Common
import Domain
import Foundation
import Moya

public enum PicplzAreasApi {
  case getAllAreas
  case searchAreas(String)
  case getNearbyAreas(rad: Int, lat: Double, lng: Double)
}

extension PicplzAreasApi: TargetType, AccessTokenAuthorizable {
  public var baseURL: URL {
    if let baseURLRaw = BundleInfos.baseURL.value,
       let baseURL = URL(string: baseURLRaw) {
        return baseURL
    } else {
      PicplzAreasApi.logger.error("BaseURL이 올바르지 않습니다.")
      fatalError("BaseURL이 올바르지 않습니다.")
    }
  }
  
  public var path: String {
    switch self {
    case .getAllAreas:
      return "/v1/areas"
    case .searchAreas:
      return "/v1/areas/search"
    case .getNearbyAreas:
      return "/v1/areas/nearby"
    }
  }
  
  public var method: Moya.Method {
    return .get
  }
  
  public var task: Moya.Task {
    switch self {
    case .getAllAreas:
      return .requestPlain
    case let .searchAreas(keyword):
      return .requestParameters(
        parameters: ["keyword": keyword],
        encoding: URLEncoding.queryString
      )
    case let .getNearbyAreas(rad, lat, lng):
      return .requestParameters(
        parameters: [
          "rad": rad,
          "lat": lat,
          "lng": lng
        ],
        encoding: URLEncoding.queryString
      )
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
    PicLogger(category: "PicplzAreasApi")
  }
}
