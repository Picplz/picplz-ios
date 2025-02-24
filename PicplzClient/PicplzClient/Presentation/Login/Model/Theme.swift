//
//  Theme.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import Foundation

struct Theme: Hashable {
    let title: String
    var userCreated: Bool = false
    
    static let predefinedThemes: [Theme] = [
        .init(title: "MZ 감성"),
        .init(title: "을지로 감성"),
        .init(title: "키치 감성"),
        .init(title: "퇴폐 감성"),
        .init(title: "올드머니 감성"),
    ]
}
