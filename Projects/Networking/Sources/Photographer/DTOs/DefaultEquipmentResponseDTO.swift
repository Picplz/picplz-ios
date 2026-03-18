//
//  DefaultEquipmentResponseDTO.swift
//  Networking
//
//  Created by 임영택 on 3/17/26.
//

import Domain

public struct DefaultEquipmentResponseDTO: Decodable {
  public let type: String
  public let brand: String
  public let name: String?
  
  func toDomain() -> PhotographerEquipment {
    .init(
      type: responseToType(),
      brand: brand,
      name: name
    )
  }
  
  private func responseToType() -> PhotographerEquipment.EquipmentType {
    switch self.type {
    case "핸드폰":
      return .phone
    case "카메라":
      return .camera(.unknown)
    default:
      return .unknown
    }
  }
}
