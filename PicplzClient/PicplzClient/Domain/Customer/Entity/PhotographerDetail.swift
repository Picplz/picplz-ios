//
//  PhotographerDetail.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import Foundation
import UIKit

struct PhotographerDetail: Hashable {
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
    let reviews: [PhotographerReview]
    
    // FIXME: just for debug. remove after implementing commuincate with backend
    static let debugList: [PhotographerDetail] = [
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
            socialId: "Gayoung",
            reviews: [
                .init(
                    authorNickname: "합정동 불주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506021),
                    updatedAt: Date(timeIntervalSince1970: 1746506021),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 무대륙",
                    comment: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
                    rating: 4.0,
                    likesCount: 4,
                    likedByCurrentUser: false
                ),
                .init(
                    authorNickname: "평창동 물주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506000),
                    updatedAt: Date(timeIntervalSince1970: 1746506000),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 자유인들",
                    comment: "쏘쏘해요",
                    rating: 3.0,
                    likesCount: 2,
                    likedByCurrentUser: true
                ),
                .init(
                    authorNickname: "응암동 한주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746505900),
                    updatedAt: Date(timeIntervalSince1970: 1746505900),
                    selectedOption: "카카오톡 패키지",
                    shootAt: "서울시 마포구 앤트러사이트",
                    comment: "감사합니다",
                    rating: 3.5,
                    likesCount: 12,
                    likedByCurrentUser: true
                )
            ]
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
            socialId: "Engang",
            reviews: [
                .init(
                    authorNickname: "합정동 불주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506021),
                    updatedAt: Date(timeIntervalSince1970: 1746506021),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 무대륙",
                    comment: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
                    rating: 4.5,
                    likesCount: 4,
                    likedByCurrentUser: false
                ),
                .init(
                    authorNickname: "평창동 물주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506000),
                    updatedAt: Date(timeIntervalSince1970: 1746506000),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 자유인들",
                    comment: "쏘쏘해요",
                    rating: 5.0,
                    likesCount: 2,
                    likedByCurrentUser: true
                ),
                .init(
                    authorNickname: "응암동 한주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746505900),
                    updatedAt: Date(timeIntervalSince1970: 1746505900),
                    selectedOption: "카카오톡 패키지",
                    shootAt: "서울시 마포구 앤트러사이트",
                    comment: "감사합니다",
                    rating: 4.5,
                    likesCount: 12,
                    likedByCurrentUser: true
                )
            ]
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
            socialId: "Seyeon",
            reviews: [
                .init(
                    authorNickname: "합정동 불주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506021),
                    updatedAt: Date(timeIntervalSince1970: 1746506021),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 무대륙",
                    comment: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
                    rating: 1.0,
                    likesCount: 4,
                    likedByCurrentUser: false
                ),
                .init(
                    authorNickname: "평창동 물주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506000),
                    updatedAt: Date(timeIntervalSince1970: 1746506000),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 자유인들",
                    comment: "쏘쏘해요",
                    rating: 2.0,
                    likesCount: 2,
                    likedByCurrentUser: true
                ),
                .init(
                    authorNickname: "응암동 한주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746505900),
                    updatedAt: Date(timeIntervalSince1970: 1746505900),
                    selectedOption: "카카오톡 패키지",
                    shootAt: "서울시 마포구 앤트러사이트",
                    comment: "감사합니다",
                    rating: 3.5,
                    likesCount: 12,
                    likedByCurrentUser: true
                )
            ]
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
            socialId: "Shinzzang",
            reviews: [
                .init(
                    authorNickname: "합정동 불주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506021),
                    updatedAt: Date(timeIntervalSince1970: 1746506021),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 무대륙",
                    comment: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
                    rating: 4.0,
                    likesCount: 4,
                    likedByCurrentUser: false
                ),
                .init(
                    authorNickname: "평창동 물주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746506000),
                    updatedAt: Date(timeIntervalSince1970: 1746506000),
                    selectedOption: "프로필 Only",
                    shootAt: "서울시 마포구 자유인들",
                    comment: "쏘쏘해요",
                    rating: 3.0,
                    likesCount: 2,
                    likedByCurrentUser: true
                ),
                .init(
                    authorNickname: "응암동 한주먹",
                    authorProfileImageUrl: nil,
                    createdAt: Date(timeIntervalSince1970: 1746505900),
                    updatedAt: Date(timeIntervalSince1970: 1746505900),
                    selectedOption: "카카오톡 패키지",
                    shootAt: "서울시 마포구 앤트러사이트",
                    comment: "감사합니다",
                    rating: 3.5,
                    likesCount: 12,
                    likedByCurrentUser: true
                )
            ]
        ),
    ]
    
    enum SocialType {
        case instagram
    }
}
