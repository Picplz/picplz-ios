//
//  MapListOrderBy.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import Foundation

enum MapListOrderBy: CaseIterable {
    case distance
    case popularity

    var title: String {
        switch self {
        case .distance:
            return "거리순"
        case .popularity:
            return "인기순"
        }
    }
}
