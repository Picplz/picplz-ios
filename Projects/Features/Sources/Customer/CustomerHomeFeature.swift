//
//  CustomerHomeFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct CustomerHomeFeature {
  @ObservableState
  public struct State: Equatable {
    public var searchQuery: String = ""
    public var location: String = "서울 전체"
    public var posts: [Post] = []
    
    @Presents var locationSelect: LocationSelectFeature.State?
    public var path = StackState<Path.State>()
    
    public init() {
      // Mock data
      self.posts = [
        Post(
          id: UUID(),
          authorName: "유가영 작가",
          authorLocation: "무대륙",
          postImagesData: [
            UIImage.sampleVertical1.pngData()!,
            UIImage.sampleVertical2.pngData()!,
            UIImage.sampleVertical1.pngData()!,
            UIImage.sampleVertical2.pngData()!,
          ],
          postLocation: "서울 마포구 와우산로 어쩌고",
          postDate: "2024. 07. 24"
        ),
        Post(
          id: UUID(),
          authorName: "홍길동 작가",
          authorLocation: "연남동",
          postImagesData: [
            UIImage.sampleVertical1.pngData()!,
            UIImage.sampleVertical2.pngData()!,
          ],
          postLocation: "서울 마포구 연남로 어쩌고",
          postDate: "2024. 07. 25"
        ),
      ]
    }
  }
  
  public struct Post: Equatable, Identifiable {
    public let id: UUID
    public let authorName: String
    public let authorLocation: String
    public let postImagesData: [Data]
    public let postLocation: String
    public let postDate: String
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case searchBarTapped
    case locationTapped
    case notificationTapped
    case profileTapped
    case reportTapped(id: UUID)
    
    case locationSelect(PresentationAction<LocationSelectFeature.Action>)
    case path(StackAction<Path.State, Path.Action>)
  }
  
  public init() {}
  
  public var body: some ReducerOf<CustomerHomeFeature> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .searchBarTapped:
        state.path.append(.searchPhotographers(SearchPhotographersFeature.State()))
        return .none
        
      case .locationTapped:
        state.locationSelect = LocationSelectFeature.State()
        return .none
        
      case .notificationTapped:
        return .none
      case .profileTapped:
        return .none
      case .reportTapped:
        return .none
        
      case .locationSelect(.presented(.applyButtonTapped)):
        if let locationState = state.locationSelect {
          state.location = locationState.selectedDistrict
        }
        state.locationSelect = nil
        return .none
        
      case .locationSelect:
        return .none
        
      case .path(.element(id: _, action: .searchPhotographers(.backButtonTapped))):
        state.path.removeLast()
        return .none
        
      case .path:
        return .none
      }
    }
    .ifLet(\.$locationSelect, action: \.locationSelect) {
      LocationSelectFeature()
    }
    .forEach(\.path, action: \.path)
  }
}

extension CustomerHomeFeature {
  @Reducer(state: .equatable)
  public enum Path {
    case searchPhotographers(SearchPhotographersFeature)
  }
}
