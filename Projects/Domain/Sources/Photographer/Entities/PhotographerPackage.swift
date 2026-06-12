//
//  PhotographerPackage.swift
//  Domain
//
//  Created by 임영택 on 4/12/26.
//

import Foundation

public struct PhotographerPackage: Equatable, Identifiable {
  public let id: UUID
  public let title: String
  public let price: String
  public let time: String
  public let info: String
  public let imageData: Data?

  public init(
    id: UUID,
    title: String,
    price: String,
    time: String,
    info: String,
    imageData: Data?
  ) {
    self.id = id
    self.title = title
    self.price = price
    self.time = time
    self.info = info
    self.imageData = imageData
  }
}

public extension PhotographerPackage {
  static let profile = PhotographerPackage(
    id: UUID(uuidString: "44444444-4444-4444-4444-444444444444") ?? UUID(),
    title: "남친 생기는 프사❤️",
    price: "9,900원",
    time: "15분 이내",
    info: "여자친구 /남자친구 생기는 카톡프사 찍어드립니당~ 요즘 인스타그램 감성으로 이쁘게! 베스트컷 5개정도 같이 뽑아드려용!",
    imageData: nil
  )

  static let wedding = PhotographerPackage(
    id: UUID(uuidString: "55555555-5555-5555-5555-555555555555") ?? UUID(),
    title: "웨딩 아이폰 스냅💍",
    price: "12,900원",
    time: "30분~1시간",
    info: "비싼 아이폰 본식 스냅! 간단하고 빠르게 찍어드립니다~~ 하객이 찍은 것처럼 자연스럽게 찍어드립디당",
    imageData: nil
  )
}
