//
//  MapListPhotographer.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import Foundation
import UIKit

struct MapListPhotographer: Hashable {
    // FIXME: ID 포함
    let name: String
    let distanceIntMeters: Int
    let walkTimeInMinutes: Int
    let isOurTownPhotographer: Bool
    let isAbleToDirectShoot: Bool
    let image: UIImage?
    let tags: [String] // FIXME: hastag 별도 타입 참조
    
    // FIXME: just for debug. remove after implementing commuincate with backend
    static let debugList: [MapListPhotographer] = [
        .init(
            name: "유가영",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: true,
            isAbleToDirectShoot: true,
            image: nil,
            tags: ["#을지로 감성", "#MZ 감성", "#퇴폐 감성",  "#어떤 감성"]
        ),
        .init(
            name: "주은강",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: true,
            isAbleToDirectShoot: false,
            image: nil,
            tags: ["#을지로 감성"]
        ),
        .init(
            name: "임세연",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: false,
            isAbleToDirectShoot: true,
            image: nil,
            tags: ["#을지로 감성"]
        ),
        .init(
            name: "짱구",
            distanceIntMeters: 200,
            walkTimeInMinutes: 3,
            isOurTownPhotographer: false,
            isAbleToDirectShoot: true,
            image: nil,
            tags: ["#을지로 감성"]
        ),
    ]
}
