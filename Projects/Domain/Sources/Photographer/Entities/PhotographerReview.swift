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

  public init(
    id: UUID,
    authorName: String,
    rating: Double,
    dateText: String,
    content: String,
    option: String,
    location: String,
    imagesData: [Data]
  ) {
    self.id = id
    self.authorName = authorName
    self.rating = rating
    self.dateText = dateText
    self.content = content
    self.option = option
    self.location = location
    self.imagesData = imagesData
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
    imagesData: []
  )
}
