//
//  PhotograperAvatarData.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit

struct PhotograperAvatarData {
    let name: String
    let distance: Double?
    let distanceUnit: DistanceUnit?
    let active: Bool
    let image: UIImage

    enum DistanceUnit {
        case km
        case m

        var displayString: String {
            switch self {
            case .km: return "km"
            case .m: return "m"
            }
        }
    }
}
