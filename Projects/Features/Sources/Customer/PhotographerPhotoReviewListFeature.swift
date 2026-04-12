//
//  PhotographerPhotoReviewListFeature.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct PhotographerPhotoReviewListFeature {
  @ObservableState
  public struct State: Equatable {
    public var photographerId: UUID
    public var photoReviews: [Data]
    
    public init(photographerId: UUID, photoReviews: [Data]) {
      self.photographerId = photographerId
      self.photoReviews = photoReviews
    }
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case imageTapped(Int)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case pushPhotoDetail(images: [Data], index: Int)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
      case let .imageTapped(index):
        return .send(.delegate(.pushPhotoDetail(images: state.photoReviews, index: index)))
      case .delegate:
        return .none
      }
    }
  }
}
