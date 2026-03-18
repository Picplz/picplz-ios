//
//  AuthRepositoryKey+Live.swift
//  CommonManifests
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Networking
import Dependencies

extension AuthRepositoryKey: @retroactive DependencyKey {
  public static var liveValue: any AuthRepositoryProtocol {
    AuthRepository()
  }
}
