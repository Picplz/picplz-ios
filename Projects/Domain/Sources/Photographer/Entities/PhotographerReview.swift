//
//  PhotographerReview.swift
//  Domain
//
//  Created by 임영택 on 4/12/26.
//

import Foundation

public struct PhotographerReview: Equatable, Identifiable {
  public let id: UUID
  public let authorName: String
  public let rating: Double
  public let dateText: String
  public let content: String
  public let option: String
  public let location: String
  public let imagesData: [Data]
  public let likeCount: Int
  public let isLiked: Bool

  public init(
    id: UUID,
    authorName: String,
    rating: Double,
    dateText: String,
    content: String,
    option: String,
    location: String,
    imagesData: [Data],
    likeCount: Int,
    isLiked: Bool
  ) {
    self.id = id
    self.authorName = authorName
    self.rating = rating
    self.dateText = dateText
    self.content = content
    self.option = option
    self.location = location
    self.imagesData = imagesData
    self.likeCount = likeCount
    self.isLiked = isLiked
  }
}

public extension PhotographerReview {
  static let mock = PhotographerReview(
    id: UUID(uuidString: "33333333-3333-3333-3333-333333333333") ?? UUID(),
    authorName: "합정동 불주먹",
    rating: 5.0,
    dateText: "2024.12.03",
    content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
    option: "남친생기는 프사",
    location: "서울시 마포구 무대륙",
    imagesData: [],
    likeCount: 4,
    isLiked: false
  )

  static let mock2 = PhotographerReview(
    id: UUID(),
    authorName: "연남동 보안관",
    rating: 4.0,
    dateText: "2024.12.05",
    content: "분위기가 너무 좋았어요! 작가님이 친절하셔서 편하게 촬영했습니다. 다음에도 또 이용하고 싶네요.",
    option: "연남동 야외촬영",
    location: "서울시 마포구 연남동",
    imagesData: [],
    likeCount: 10,
    isLiked: true
  )

  static let mock3 = PhotographerReview(
    id: UUID(),
    authorName: "망원동 다람쥐",
    rating: 4.5,
    dateText: "2024.11.20",
    content: "망원동 골목 구석구석 숨은 명소를 잘 알고 계셔서 좋았어요. 사진 색감도 마음에 듭니다.",
    option: "아날로그 감성 스냅",
    location: "서울시 마포구 망원동",
    imagesData: [],
    likeCount: 2,
    isLiked: false
  )

  static let mock4 = PhotographerReview(
    id: UUID(),
    authorName: "상수동 고양이",
    rating: 3.5,
    dateText: "2024.12.10",
    content: "촬영은 좋았으나 대기 시간이 조금 길었습니다. 그래도 결과물은 만족스러워요.",
    option: "카페 실내 촬영",
    location: "서울시 마포구 상수동",
    imagesData: [],
    likeCount: 0,
    isLiked: false
  )

  static let mocks: [PhotographerReview] = [mock, mock2, mock3, mock4]
}
