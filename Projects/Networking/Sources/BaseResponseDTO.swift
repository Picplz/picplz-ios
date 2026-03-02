//
//  BaseResponseDTO.swift
//  Networking
//
//  Created by 임영택 on 2/28/26.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
  let timestamp: Date
  let statusCode: Int
  let message: String
  let data: T
}
