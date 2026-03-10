//
//  Role.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Foundation

public enum Role {
  case customer
  case photographer
  
  public static func from(rawValue: String) -> Self? {
    switch rawValue.lowercased() {
    case "customer":
      return .customer
    case "photographer":
      return .photographer
    default:
      return nil
    }
  }
}
