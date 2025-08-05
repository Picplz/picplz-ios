//
//  CustomerRegisterDTO.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation

struct CustomerRegisterDTO: Encodable {
    let nickname: String?
    let socialEmail: String
    let socialCode: String
    let socialProvider: String
}
