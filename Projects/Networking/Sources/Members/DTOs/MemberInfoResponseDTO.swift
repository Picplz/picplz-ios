//
//  MemberInfoResponseDTO.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Foundation

struct MemberInfoResponseDTO: Decodable {
  let id: Int
  let nickname: String
  let role: String
  let socialEmail: String
  let profileImage: String
  let socialProvider: String
  let socialCode: String
}
