//
//  ProfileImageUploadUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension ProfileImageUploadUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: ProfileImageUploadUseCase {
    @Dependency(\.s3Repository) var s3Repository
    return .live(s3Repository: s3Repository)
  }
}
