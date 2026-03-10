//
//  CreateCustomerRequestDTO.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Foundation

public struct CreateCustomerRequestDTO: Encodable {
  public let nickname: String
  public let socialEmail: String
  public let socialProvider: String
  public let socialCode: String
  public let profileImage: String
  public init(nickname: String, socialEmail: String, socialProvider: String, socialCode: String, profileImage: String) {
    self.nickname = nickname
    self.socialEmail = socialEmail
    self.socialProvider = socialProvider
    self.socialCode = socialCode
    self.profileImage = profileImage
  }
}
