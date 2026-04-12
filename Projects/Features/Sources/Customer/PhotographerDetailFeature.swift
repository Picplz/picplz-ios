//
//  PhotographerDetailFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
import Domain
import Foundation
import SwiftUI

@Reducer
public struct PhotographerDetailFeature {
  @ObservableState
  public struct State: Equatable {
    public var photographer: PhotographerDetail
    public var isDescriptionExpanded: Bool = false
    public var isLocationExpanded: Bool = false
    
    public init(photographer: PhotographerDetail = .mock) {
      self.photographer = photographer
    }
  }
  
  public enum Action: Hashable {
    case backButtonTapped
    case moreButtonTapped
    case followButtonTapped
    case expandDescriptionTapped
    case expandLocationTapped
    case reserveButtonTapped
    case unblockButtonTapped
    case reportReviewTapped(UUID)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .expandDescriptionTapped:
        state.isDescriptionExpanded.toggle()
        return .none
        
      case .expandLocationTapped:
        state.isLocationExpanded.toggle()
        return .none
        
      case .unblockButtonTapped:
        state.photographer.isBlocked = false
        return .none
        
      case .backButtonTapped, .moreButtonTapped, .followButtonTapped, 
           .reserveButtonTapped, .reportReviewTapped:
        return .none
      }
    }
  }
}
