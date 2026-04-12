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
    public var path = StackState<Path.State>()
    
    public init(photographer: PhotographerDetail = .mock) {
      self.photographer = photographer
    }
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case moreButtonTapped
    case followButtonTapped
    case expandDescriptionTapped
    case expandLocationTapped
    case reserveButtonTapped
    case unblockButtonTapped
    case reportReviewTapped(UUID)
    case reviewListButtonTapped
    case path(StackAction<Path.State, Path.Action>)
  }
  
  @Reducer
  public enum Path {
    case reviewList(PhotographerReviewListFeature)
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
        
      case .reviewListButtonTapped:
        state.path.append(.reviewList(PhotographerReviewListFeature.State(
          photographerId: state.photographer.id,
          photographerName: state.photographer.name,
          rating: state.photographer.rating,
          reviewCount: state.photographer.reviewCount,
          reviews: state.photographer.reviews,
          allReviewImages: state.photographer.reviews.flatMap { $0.imagesData }
        )))
        return .none
        
      case let .path(.element(id: _, action: .reviewList(.backButtonTapped))):
        _ = state.path.popLast()
        return .none
        
      case .backButtonTapped, .moreButtonTapped, .followButtonTapped, 
           .reserveButtonTapped, .reportReviewTapped, .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension PhotographerDetailFeature.Path.State: Equatable {}
extension PhotographerDetailFeature.Path.Action: Equatable {}
