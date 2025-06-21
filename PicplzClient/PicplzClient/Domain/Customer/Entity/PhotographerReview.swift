//
//  PhotographerReview.swift
//  PicplzClient
//
//  Created by 임영택 on 5/6/25.
//

import Foundation

struct PhotographerReview: Hashable {
    let authorNickname: String
    let authorProfileImageUrl: URL?
    let createdAt: Date
    let updatedAt: Date
    let selectedOption: String
    let shootAt: String
    let comment: String
    let rating: Float
    let likesCount: Int
    let likedByCurrentUser: Bool
}
