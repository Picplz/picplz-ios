//
//  S3RepositoryKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Networking
import Dependencies

extension S3RepositoryKey: @retroactive DependencyKey {
  public static var liveValue: any S3RepositoryProtocol {
    S3Repository()
  }
}
