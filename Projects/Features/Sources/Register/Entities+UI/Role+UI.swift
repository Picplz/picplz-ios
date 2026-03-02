//
//  Role+UI.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import Domain
import SwiftUI

extension Role {
  var displayLabel: String {
    switch self {
    case .model: return "고객"
    case .photographer: return "찍사"
    }
  }
  
  var activeIconImage: ImageResource {
    switch self {
    case .model: return .selectorModel
    case .photographer: return .selectorPhotographer
    }
  }
  
  var inactiveIconImage: ImageResource {
    switch self {
    case .model: return .selectorModelInactive
    case .photographer: return .selectorPhotographerInactive
    }
  }
}
