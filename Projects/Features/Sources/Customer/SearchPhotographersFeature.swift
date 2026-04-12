//
//  SearchPhotographersFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct SearchPhotographersFeature {
  @ObservableState
  public struct State: Equatable {
    public var searchQuery: String = ""
    public var photographers: [Photographer] = []
    public var searchResultState: SearchResultState = .idle
    public var sortOrder: SortOrder = .rating
    
    @Presents var sortModal: SortSelectFeature.State?
    
    public init() {}
  }
  
  public enum SearchResultState: Equatable {
    case idle
    case searching
    case results
    case noResults
  }
  
  public enum SortOrder: String, CaseIterable, Equatable {
    case rating = "별점순"
    case reviews = "리뷰많은순"
    case followers = "팔로워순"
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case backButtonTapped
    case clearButtonTapped
    case searchButtonTapped
    case sortDropdownTapped
    case photographerTapped(UUID)
    case sortModal(PresentationAction<SortSelectFeature.Action>)
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case pushPhotographerDetail(PhotographerDetail)
  }
  
  public init() {}
  
  @Dependency(\.continuousClock) var clock
  private enum CancelID { case search }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.searchQuery):
        if state.searchQuery.isEmpty {
          state.searchResultState = .idle
          return .cancel(id: CancelID.search)
        }
        
        return .run { [query = state.searchQuery] send in
          try await self.clock.sleep(for: .milliseconds(300))
          await send(.searchButtonTapped)
        }
        .cancellable(id: CancelID.search, cancelInFlight: true)
        
      case .clearButtonTapped:
        state.searchQuery = ""
        state.searchResultState = .idle
        return .cancel(id: CancelID.search)
        
      case .searchButtonTapped:
        if state.searchQuery.isEmpty { return .none }
        
        state.searchResultState = .searching
        // 검색 시뮬레이션 (더미 데이터)
        if state.searchQuery == "없음" {
          state.searchResultState = .noResults
        } else {
          state.photographers = [
            Photographer(id: UUID(), name: "유가영 작가", districts: "마포구, 서대문구", tags: ["#을지로 감성", "#MZ 감성"], isFastShootAvailable: true, profileImageData: nil),
            Photographer(id: UUID(), name: "홍길동 작가", districts: "동작구, 영등포구", tags: ["#자연광", "#야외촬영"], isFastShootAvailable: false, profileImageData: nil)
          ]
          state.searchResultState = .results
        }
        return .none
        
      case .sortDropdownTapped:
        state.sortModal = SortSelectFeature.State(selectedOrder: state.sortOrder)
        return .none
        
      case let .sortModal(.presented(.selectOrder(order))):
        state.sortOrder = order
        state.sortModal = nil
        return .none
        
      case .sortModal:
        return .none
        
      case let .photographerTapped(id):
        // TODO: 실제 작가 상세 정보를 가져오는 API 연동 필요
        return .send(.delegate(.pushPhotographerDetail(.mock)))

      case .backButtonTapped, .binding, .delegate:
        return .none
      }
    }
    .ifLet(\.$sortModal, action: \.sortModal) {
      SortSelectFeature()
    }
  }
}

// MARK: - Photographer Model
public struct Photographer: Equatable, Identifiable {
  public let id: UUID
  public let name: String
  public let districts: String
  public let tags: [String]
  public let isFastShootAvailable: Bool
  public let profileImageData: Data?
}

// MARK: - SortSelectFeature
@Reducer
public struct SortSelectFeature {
  @ObservableState
  public struct State: Equatable {
    public var selectedOrder: SearchPhotographersFeature.SortOrder
  }
  
  public enum Action: Equatable {
    case selectOrder(SearchPhotographersFeature.SortOrder)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .selectOrder:
        return .none
      }
    }
  }
}
