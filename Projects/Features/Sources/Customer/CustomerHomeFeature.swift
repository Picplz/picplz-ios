//
//  CustomerHomeFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
import Foundation
import SwiftUI

extension CustomerHomeFeature {
  @Reducer
  public enum Path {
    case searchPhotographers(SearchPhotographersFeature)
    case photographerDetail(PhotographerDetailFeature)
    case reviewList(PhotographerReviewListFeature)
    case photoReviewList(PhotographerPhotoReviewListFeature)
    case photoDetail(PhotographerPhotoDetailFeature)
  }
}

extension CustomerHomeFeature.Path.State: Equatable {}
extension CustomerHomeFeature.Path.Action: Equatable {} // Type 'CustomerHomeFeature.Path.Action' does not conform to protocol 'Equatable'

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
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchBarTapped
    case locationTapped
    case notificationTapped
    case profileTapped
    case reportTapped(id: UUID)
    
    case locationSelect(PresentationAction<LocationSelectFeature.Action>)
    case path(StackAction<Path.State, Path.Action>)

    public static func == (lhs: Action, rhs: Action) -> Bool {
      switch (lhs, rhs) {
      case (.binding, .binding): return true
      case (.searchBarTapped, .searchBarTapped): return true
      case (.locationTapped, .locationTapped): return true
      case (.notificationTapped, .notificationTapped): return true
      case (.profileTapped, .profileTapped): return true
      case let (.reportTapped(l), .reportTapped(r)): return l == r
      case let (.locationSelect(l), .locationSelect(r)): return l == r
      case let (.path(l), .path(r)): return l == r
      default: return false
      }
    }
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
        
      case let .path(.element(id: _, action: .searchPhotographers(.backButtonTapped))):
        _ = state.path.popLast()
        return .none

      case let .path(.element(id: _, action: .searchPhotographers(.delegate(.pushPhotographerDetail(photographer))))):
        state.path.append(.photographerDetail(PhotographerDetailFeature.State(photographer: photographer)))
        return .none

      case let .path(.element(id: _, action: .photographerDetail(.backButtonTapped))):
        _ = state.path.popLast()
        return .none

      case let .path(.element(id: _, action: .photographerDetail(.delegate(.pushReviewList(reviewState))))):
        state.path.append(.reviewList(reviewState))
        return .none

      case let .path(.element(id: _, action: .reviewList(.backButtonTapped))):
        _ = state.path.popLast()
        return .none

      case let .path(.element(id: _, action: .reviewList(.delegate(.pushPhotoReviewList(id, photos))))):
        state.path.append(.photoReviewList(PhotographerPhotoReviewListFeature.State(photographerId: id, photoReviews: photos)))
        return .none

      case let .path(.element(id: _, action: .photoReviewList(.backButtonTapped))):
        _ = state.path.popLast()
        return .none

      case let .path(.element(id: _, action: .photoReviewList(.delegate(.pushPhotoDetail(images, index))))):
        state.path.append(.photoDetail(PhotographerPhotoDetailFeature.State(images: images, currentIndex: index)))
        return .none

      case let .path(.element(id: _, action: .photoDetail(.backButtonTapped))):
        _ = state.path.popLast()
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
