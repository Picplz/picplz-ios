//
//  PhotographerDetailFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
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

// MARK: - Entity
public struct PhotographerDetail: Equatable {
  public let id: UUID
  public let name: String
  public let profileImageData: Data?
  public let instagramId: String
  public let followerCount: Int
  public let description: String
  public let locations: String
  public let keywords: [String]
  public let equipments: String
  public let rating: Double
  public let reviewCount: Int
  public var isBookable: Bool
  public var isBlocked: Bool
  
  public static let mock = PhotographerDetail(
    id: UUID(),
    name: "유가영 작가",
    profileImageData: nil,
    instagramId: "Gayoung",
    followerCount: 112,
    description: "10/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 안녕하세요! 사진 찍는 유가영입니다.",
    locations: "마포구, 동작구, 머머구 외 5개",
    keywords: ["#캐주얼", "#고급미"],
    equipments: "아이폰 16 PRO, 아이폰X, 갤럭시23 울트라",
    rating: 4.5,
    reviewCount: 32,
    isBookable: true,
    isBlocked: false
  )
}
