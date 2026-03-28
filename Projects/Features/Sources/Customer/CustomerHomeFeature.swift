//
//  CustomerHomeFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
import Foundation
import SwiftUI  // TODO: 샘플 이미지 제거하면 필요 없음

@Reducer
public struct CustomerHomeFeature {
  @ObservableState
  public struct State: Equatable {
    public var searchQuery: String = ""
    public var location: String = "서울 전체"
    public var posts: [Post] = []

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

  // TODO: move to domain
  public struct Post: Equatable, Identifiable {
    public let id: UUID
    public let authorName: String
    public let authorLocation: String
    public let postImagesData: [Data] // 도메인 모듈이므로 UIImage가 아닌 제너럴한 타입인 Data를 가지게 함
    public let postLocation: String
    public let postDate: String
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case searchButtonTapped
    case locationTapped
    case notificationTapped
    case profileTapped
    case reportTapped(id: UUID)
  }

  public init() {}

  public var body: some ReducerOf<CustomerHomeFeature> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .searchButtonTapped:
        return .none
      case .locationTapped:
        return .none
      case .notificationTapped:
        return .none
      case .profileTapped:
        return .none
      case .reportTapped:
        return .none
      }
    }
  }
}
