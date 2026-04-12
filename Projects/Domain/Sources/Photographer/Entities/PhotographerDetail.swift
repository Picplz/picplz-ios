//
//  PhotographerDetail.swift
//  Domain
//
//  Created by 임영택 on 4/12/26.
//

import Foundation

public struct PhotographerDetail: Equatable {
  public let id: UUID
  public let name: String
  public let profileImageData: Data?
  public let instagramId: String
  public let followerCount: Int
  public let description: String
  public let locations: [String]
  public let keywords: [String]
  public let equipments: [String]
  public let rating: Double
  public let reviewCount: Int
  public let reviews: [PhotographerReview]
  public let portfolioImagesData: [Data]
  public let packages: [PhotographerPackage]
  public var isBookable: Bool
  public var isBlocked: Bool

  public init(
    id: UUID,
    name: String,
    profileImageData: Data?,
    instagramId: String,
    followerCount: Int,
    description: String,
    locations: [String],
    keywords: [String],
    equipments: [String],
    rating: Double,
    reviewCount: Int,
    reviews: [PhotographerReview],
    portfolioImagesData: [Data],
    packages: [PhotographerPackage],
    isBookable: Bool,
    isBlocked: Bool
  ) {
    self.id = id
    self.name = name
    self.profileImageData = profileImageData
    self.instagramId = instagramId
    self.followerCount = followerCount
    self.description = description
    self.locations = locations
    self.keywords = keywords
    self.equipments = equipments
    self.rating = rating
    self.reviewCount = reviewCount
    self.reviews = reviews
    self.portfolioImagesData = portfolioImagesData
    self.packages = packages
    self.isBookable = isBookable
    self.isBlocked = isBlocked
  }
}

public extension PhotographerDetail {
  static let mock = PhotographerDetail(
    id: UUID(uuidString: "11111111-1111-1111-1111-111111111111") ?? UUID(),
    name: "유가영 작가",
    profileImageData: nil,
    instagramId: "Gayoung",
    followerCount: 112,
    description: "10/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 안녕하세요! 사진 찍는 유가영입니다.",
    locations: ["마포구", "동작구", "성동구", "용산구", "서대문구", "은평구", "영등포구"],
    keywords: ["#캐주얼", "#고급미"],
    equipments: ["아이폰 16 PRO", "아이폰X", "갤럭시23 울트라"],
    rating: 4.5,
    reviewCount: 32,
    reviews: PhotographerReview.mocks,
    portfolioImagesData: [],
    packages: [.profile, .wedding],
    isBookable: true,
    isBlocked: false
  )

  static let blockedMock = PhotographerDetail(
    id: UUID(uuidString: "22222222-2222-2222-2222-222222222222") ?? UUID(),
    name: "유가영 작가",
    profileImageData: nil,
    instagramId: "Gayoung",
    followerCount: 112,
    description: "차단된 작가입니다.",
    locations: [],
    keywords: [],
    equipments: [],
    rating: 0.0,
    reviewCount: 0,
    reviews: [],
    portfolioImagesData: [],
    packages: [],
    isBookable: false,
    isBlocked: true
  )
}
