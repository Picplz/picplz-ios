//
//  PhotographerRegisterRequestExtra.swift
//  Domain
//
//  Created by 임영택 on 3/9/26.
//

import Foundation

public struct PhotographerRegisterRequestExtra: Equatable {
  // MARK: 작가 전용
  var photoMoods: [PhotographerPhotoMood]
  var activeAreas: [PhotographerActiveArea]
  var cameras: [PhotographerEquipment]
  
  public init(photoMoods: [PhotographerPhotoMood], activeAreas: [PhotographerActiveArea], cameras: [PhotographerEquipment]) {
    self.photoMoods = photoMoods
    self.activeAreas = activeAreas
    self.cameras = cameras
  }
  
  public struct PhotographerActiveArea: Equatable {
    let code: Int
    let priority: Int
  }
}

public typealias PhotographerPhotoMood = String
