//
//  BaseResponse.swift
//  PicplzClient
//
//  Created by 임영택 on 9/1/25.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let timestamp: String
    let statusCode: Int
    let message: String
    let data: T
}
