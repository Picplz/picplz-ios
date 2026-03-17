//
//  Area.swift
//  Domain
//
//  Created by 임영택 on 3/15/26.
//

import Foundation

public struct Area: Equatable, Hashable {
  public let id: Int64
  public let name: String
  public let dong: String
  public let ri: String
  
  public init(id: Int64, name: String, dong: String, ri: String) {
    self.id = id
    self.name = name
    self.dong = dong
    self.ri = ri
  }
}
