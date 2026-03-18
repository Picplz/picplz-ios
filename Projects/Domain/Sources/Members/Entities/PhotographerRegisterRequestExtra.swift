//
//  PhotographerRegisterRequestExtra.swift
//  Domain
//
//  Created by 임영택 on 3/9/26.
//

import Foundation

public struct PhotographerRegisterRequestExtra: Equatable {
  // MARK: 작가 전용
  public var photoMoods: [PhotographerPhotoMood]
  public var activeAreas: [Area]
  public var cameras: [PhotographerEquipment]
  
  public init(photoMoods: [PhotographerPhotoMood], activeAreas: [Area], cameras: [PhotographerEquipment]) {
    self.photoMoods = photoMoods
    self.activeAreas = activeAreas
    self.cameras = cameras
  }
}

public typealias PhotographerPhotoMood = String
