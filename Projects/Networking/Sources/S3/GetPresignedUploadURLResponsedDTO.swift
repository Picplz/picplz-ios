//
//  GetPresignedUploadURLResponsedDTO.swift
//  Networking
//
//  Created by 임영택 on 3/10/26.
//

import Foundation

struct GetPresignedUploadURLResponsedDTO: Decodable {
  let objectKey: String
  let uploadUrl: String
}
