//
//  HTTPError.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Foundation
import Moya

public enum HTTPError: Error, LocalizedError {
  case BadRequest(response: String)
  case ServerError(response: String)
  
  public var errorDescription: String? {
    switch self {
    case .BadRequest(let response):
      return "Status Code 4xx 에러가 발생했습니다. \(response)"
    case .ServerError(let response):
      return "Status Code 5xx 에러가 발생했습니다. \(response)"
    }
  }
  
  static public func checkError(response: Moya.Response) throws {
    if (200...299).contains(response.statusCode) {
      return
    }
    
    if (400...499).contains(response.statusCode) {
      throw HTTPError.BadRequest(response: String(data: response.data, encoding: .utf8) ?? "No Response")
    }
    
    if (500...599).contains(response.statusCode) {
      throw HTTPError.ServerError(response: String(data: response.data, encoding: .utf8) ?? "No Response")
    }
  }
}
