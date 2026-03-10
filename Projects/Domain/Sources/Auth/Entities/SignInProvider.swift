//
//  SignInProvider.swift
//  Domain
//
//  Created by 임영택 on 2/3/26.
//

import Foundation

public enum SignInProvider: CaseIterable {
  case kakao
  case apple
  
  public static func from(rawValue: String) -> Self? {
    switch rawValue.lowercased() {
    case "kakao":
      return .kakao
    case "apple":
      return .apple
    default:
      return nil
    }
  }
}
