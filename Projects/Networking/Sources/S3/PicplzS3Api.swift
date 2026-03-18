//
//  PicplzS3Api.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Common
import Foundation
import Moya

public enum PicplzS3Api {
  case getPresignedUploadURL(fileType: String, fileName: String)
}

extension PicplzS3Api: TargetType {
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
    case .getPresignedUploadURL:
      return "/v1/s3/presigned-upload-url"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .getPresignedUploadURL:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case let .getPresignedUploadURL(fileType, fileName):
      return .requestParameters(
        parameters: [
          "filename": fileName,
          "imageType": fileType
        ],
        encoding: URLEncoding.queryString
      )
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
