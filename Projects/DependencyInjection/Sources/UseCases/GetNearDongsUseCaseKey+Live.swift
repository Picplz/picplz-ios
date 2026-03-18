//
//  GetNearDongsUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension GetNearDongsUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: GetNearDongsUseCase {
    @Dependency(\.locationManagerService) var locationManagerService
    @Dependency(\.areasRepository) var areasRepository
    return .live(locationManagerService: locationManagerService, areasRepository: areasRepository)
  }
}
