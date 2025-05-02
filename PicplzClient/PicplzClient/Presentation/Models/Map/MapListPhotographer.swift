//
//  MapListPhotographer.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import Foundation
import UIKit

struct MapListPhotographer: Hashable {
    let id: Int
    let name: String
    let introduction: String
    let distanceIntMeters: Int
    let walkTimeInMinutes: Int
    let isOurTownPhotographer: Bool
    let isAbleToDirectShoot: Bool
    let image: UIImage?
    let towns: [String] // FIXME: town 별도 타입 참조
    let tags: [String] // FIXME: hastag 별도 타입 참조
    let followers: Int
    let socialType: SocialType
    let socialId: String
    
    // FIXME: just for debug. remove after implementing commuincate with backend
    static let debugList: [MapListPhotographer] = [
        .init(
            id: 1,
            name: "유가영",
            introduction: "10/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 블라블라세이헬로",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: true,
            isAbleToDirectShoot: true,
            image: nil,
            towns: ["서울시 마포구", "서울시 용산구", "서울시 영등포구", "서울시 중구", "서울시 남대문구"],
            tags: ["#을지로 감성", "#MZ 감성", "#퇴폐 감성",  "#어떤 감성"],
            followers: 128,
            socialType: .instagram,
            socialId: "Gayoung"
        ),
        .init(
            id: 2,
            name: "주은강",
            introduction: "9/30 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다.",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: true,
            isAbleToDirectShoot: false,
            image: nil,
            towns: ["서울시 마포구", "서울시 용산구", "서울시 영등포구", "서울시 중구", "서울시 남대문구"],
            tags: ["#을지로 감성"],
            followers: 64,
            socialType: .instagram,
            socialId: "Engang"
        ),
        .init(
            id: 3,
            name: "임세연",
            introduction: "8/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다.",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: false,
            isAbleToDirectShoot: true,
            image: nil,
            towns: ["서울시 마포구", "서울시 용산구", "서울시 영등포구", "서울시 중구", "서울시 남대문구"],
            tags: ["#을지로 감성"],
            followers: 32,
            socialType: .instagram,
            socialId: "Seyeon"
        ),
        .init(
            id: 4,
            name: "짱구",
            introduction: "7/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 한 것도 없는데 벌써 네 시...",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: false,
            isAbleToDirectShoot: false,
            image: nil,
            towns: ["서울시 마포구", "서울시 용산구", "서울시 영등포구", "서울시 중구", "서울시 남대문구"],
            tags: ["#을지로 감성"],
            followers: 16,
            socialType: .instagram,
            socialId: "Shinzzang"
        ),
    ]
    
    enum SocialType {
        case instagram
    }
}
