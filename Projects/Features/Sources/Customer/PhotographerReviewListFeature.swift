//
//  PhotographerReviewListFeature.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct PhotographerReviewListFeature {
  @ObservableState
  public struct State: Equatable {
    public var photographerId: UUID
    public var photographerName: String
    public var rating: Double
    public var reviewCount: Int
    public var reviews: [PhotographerReview]
    public var allReviewImages: [Data]
    public var sortOrder: SortOrder = .recommended
    
    @Presents var sortModal: SortSelectFeature.State?
    
    public init(
      photographerId: UUID,
      photographerName: String,
      rating: Double,
      reviewCount: Int,
      reviews: [PhotographerReview],
      allReviewImages: [Data]
    ) {
      self.photographerId = photographerId
      self.photographerName = photographerName
      self.rating = rating
      self.reviewCount = reviewCount
      self.reviews = reviews
      self.allReviewImages = allReviewImages
    }
  }
  
  public enum Action: Equatable {
    case backButtonTapped
    case sortDropdownTapped
    case likeButtonTapped(UUID)
    case reportButtonTapped(UUID)
    case sortModal(PresentationAction<SortSelectFeature.Action>)
    
    // TODO: 페이지네이션 및 소팅 관련 액션 추가
    case onAppear
    case fetchReviews(isNextPage: Bool)
    case reviewsResponse(Result<[PhotographerReview], ReviewError>)
  }

  public enum ReviewError: Error, Equatable {
    case unknown
    case network(String)
  }
  
  public enum SortOrder: String, CaseIterable, Equatable {
    case recommended = "추천순"
    case newest = "최신순"
    case mostLiked = "좋아요순"
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        // TODO: 초기 리뷰 목록 페치 (Cursor: nil)
        return .none

      case .fetchReviews(let isNextPage):
        // TODO: 커서 기반 페이지네이션 API 호출 로직 구현
        // isNextPage가 true이면 마지막 리뷰의 ID/커서를 사용하여 다음 페이지 요청
        return .none

      case .reviewsResponse(.success(let reviews)):
        // TODO: 페이징 데이터 처리 (append or replace)
        return .none

      case .reviewsResponse(.failure(let error)):
        // TODO: 에러 핸들링
        return .none

      case .backButtonTapped:
        return .none
        
      case .sortDropdownTapped:
        state.sortModal = SortSelectFeature.State(selectedOrder: state.sortOrder)
        return .none
        
      case let .sortModal(.presented(.selectOrder(order))):
        state.sortOrder = order
        state.sortModal = nil
        // TODO: 소팅 변경 시 목록 초기화 및 재조회 (fetchReviews(isNextPage: false))
        return .none
        
      case .sortModal:
        return .none
        
      case .likeButtonTapped, .reportButtonTapped:
        return .none
      }
    }
    .ifLet(\.$sortModal, action: \.sortModal) {
      SortSelectFeature()
    }
  }
}

extension PhotographerReviewListFeature {
  @Reducer
  public struct SortSelectFeature {
    @ObservableState
    public struct State: Equatable {
      public var selectedOrder: SortOrder
    }
    
    public enum Action: Equatable {
      case selectOrder(SortOrder)
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
}
