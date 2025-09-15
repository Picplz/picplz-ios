//
//  Theme.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import Foundation

struct Theme: Hashable {
    private(set) var title: String
    var userCreated: Bool = false
    var initialized: Bool = true

    static let predefinedThemes: [Theme] = [
        .init(title: "MZ 감성"),
        .init(title: "을지로 감성"),
        .init(title: "키치 감성"),
        .init(title: "퇴폐 감성"),
        .init(title: "올드머니 감성")
    ]

    /**
        커스텀 감성인 경우 타이틀을 변경하고 true를 반환한다.
        시스템 기본 제공인 경우 변경하지 않고 false를 반환한다.
     */
    mutating func setTitle(to title: String) -> Bool {
        guard userCreated else { return false }

        self.title = title
        return true
    }
}
