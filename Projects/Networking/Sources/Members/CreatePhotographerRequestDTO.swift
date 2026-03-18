//
//  CreatePhotographerRequestDTO.swift
//  Networking
//
//  Created by 임영택 on 3/18/26.
//

import Foundation

public struct CreatePhotographerRequestDTO: Encodable {
  public let nickname: String
  public let socialEmail: String
  public let socialProvider: String
  public let socialCode: String
  public let profileImage: String
  public let photoMoods: [String]
  public let activeAreas: [ActiveAreaDTO]
  public let cameras: [CameraDTO]
  
  public init(
    nickname: String,
    socialEmail: String,
    socialProvider: String,
    socialCode: String,
    profileImage: String,
    photoMoods: [String],
    activeAreas: [ActiveAreaDTO],
    cameras: [CameraDTO]
  ) {
    self.nickname = nickname
    self.socialEmail = socialEmail
    self.socialProvider = socialProvider
    self.socialCode = socialCode
    self.profileImage = profileImage
    self.photoMoods = photoMoods
    self.activeAreas = activeAreas
    self.cameras = cameras
  }
}

public struct ActiveAreaDTO: Encodable {
  public let code: Int64
  public let priority: Int
  
  public init(code: Int64, priority: Int) {
    self.code = code
    self.priority = priority
  }
}

public struct CameraDTO: Encodable {
  public let type: String
  public let brand: String
  public let name: String
  public let cameraType: String
  
  public init(type: String, brand: String, name: String, cameraType: String) {
    self.type = type
    self.brand = brand
    self.name = name
    self.cameraType = cameraType
  }
}
