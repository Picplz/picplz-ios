//
//  TokenStorageKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Storage
import Dependencies

extension TokenStorageKey: @retroactive DependencyKey {
  public static var liveValue: any TokenStorageProtocol {
    KeychainStorage()
  }
}
