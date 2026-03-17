//
//  AreaInfoResponseDTO.swift
//  Networking
//
//  Created by 임영택 on 3/15/26.
//

import Foundation

public struct AreaInfoResponseDTO: Decodable {
  public let id: Int64
  public let name: String
  public let dong: String
  public let ri: String
}
