//
//  PhotographerPackage.swift
//  PicplzClient
//
//  Created by 임영택 on 6/21/25.
//

import Foundation

struct PhotographerPackage {
    let packageName: String
    let price: Int
    let numberOfPhots: String // 촬영 컷수
    let shootingTimes: String // 촬영 시간
    let inclueAdjust: String // 보정 여부
    let extraNotice: String // 기타 안내
    let bannerImageUrl: URL?
    
    static let debugData: [PhotographerPackage] = [
        .init(packageName: "프로필 Only", price: 9900, numberOfPhots: "10컷 + a", shootingTimes: "10분 이내", inclueAdjust: "장당 + 1,000원, 원본 제공", extraNotice: "자유롭게 작가가 쓸수있는 기타공지사항...", bannerImageUrl: nil),
        .init(packageName: "카카오톡 패키지", price: 9900, numberOfPhots: "9컷 + b", shootingTimes: "9분 이내", inclueAdjust: "장당 + 1,000원, 원본 제공", extraNotice: "자유롭게 작가가 쓸수있는 기타공지사항...", bannerImageUrl: nil),
        .init(packageName: "인스타그램 패키지", price: 9900, numberOfPhots: "8컷 + c", shootingTimes: "8분 이내", inclueAdjust: "장당 + 1,000원, 원본 제공", extraNotice: "자유롭게 작가가 쓸수있는 기타공지사항...", bannerImageUrl: nil),
    ]
}
