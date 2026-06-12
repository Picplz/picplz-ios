//
//  PhotographerPhotoDetailFeature.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PhotographerPhotoDetailFeature {
  @ObservableState
  public struct State: Equatable {
    public var images: [Data]
    public var currentIndex: Int
    
    public init(images: [Data], currentIndex: Int) {
      self.images = images
      self.currentIndex = currentIndex
    }
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case imagePaged(Int)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        return .none
      case let .imagePaged(index):
        state.currentIndex = index
        return .none
      }
    }
  }
}
