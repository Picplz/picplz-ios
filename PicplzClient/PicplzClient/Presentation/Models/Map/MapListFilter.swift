//
//  MapListFilter.swift
//  PicplzClient
//
//  Created by 임영택 on 4/8/25.
//

import Foundation
import UIKit

struct MapListFilter: Hashable {
    let filterId: String
    let filterTitle: String
    let image: UIImage?
    let type: FilterType
    var isSelected: Bool

    static var photographerFilters: [MapListFilter] = [
        .init(filterId: "following", filterTitle: "팔로우", image: UIImage(named: "CheckSymbol"), type: .photographerFilter, isSelected: false),
        .init(filterId: "direct", filterTitle: "바로 촬영 가능", image: UIImage(named: "CameraSymbol"), type: .photographerFilter, isSelected: false)
    ]

    static var hashTagFilters: [MapListFilter] = [
        .init(filterId: "eljiro", filterTitle: "#을지로 감성", image: nil, type: .hashTagFilter, isSelected: true),
        .init(filterId: "kitsch", filterTitle: "#키치 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterId: "mz", filterTitle: "#MZ 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterId: "demoral", filterTitle: "#퇴폐 감성", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterId: "test1", filterTitle: "#어떤 감성1", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterId: "test2", filterTitle: "#어떤 감성2", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterId: "test3", filterTitle: "#어떤 감성3", image: nil, type: .hashTagFilter, isSelected: false),
        .init(filterId: "test4", filterTitle: "#어떤 감성4", image: nil, type: .hashTagFilter, isSelected: false)
    ]

    enum FilterType {
        case photographerFilter
        case hashTagFilter
    }
}
