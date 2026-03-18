//
//  PhotographerEquipment.swift
//  Domain
//
//  Created by 임영택 on 3/9/26.
//

public struct PhotographerEquipment: Hashable {
  public var type: EquipmentType
  public var brand: String
  public var name: String?
  
  public init(type: EquipmentType, brand: String, name: String?) {
    self.type = type
    self.brand = brand
    self.name = name
  }
  
  public enum EquipmentType: Hashable {
    case phone
    case camera(CameraType)
    case unknown
    
    public enum CameraType: Hashable, CaseIterable {
      case dslrCamera
      case mirrorlessCamera
      case campactCamera
      case filmCamera
      case unknown
    }
  }
}
