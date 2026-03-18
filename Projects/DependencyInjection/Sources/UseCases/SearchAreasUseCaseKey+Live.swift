//
//  SearchAreasUseCaseKey+Live.swift
//  DependencyInjection
//
//  Created by 임영택 on 3/18/26.
//

import Domain
import Dependencies

extension SearchAreasUseCaseKey: @retroactive DependencyKey {
  public static var liveValue: SearchAreasUseCase {
    @Dependency(\.areasRepository) var areasRepository
    return .live(areasRepository: areasRepository)
  }
}
