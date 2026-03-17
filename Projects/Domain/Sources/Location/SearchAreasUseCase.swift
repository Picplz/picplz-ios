//
//  SearchAreasUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/17/26.
//

import Dependencies

public struct SearchAreasUseCase {
  public var execute: (_ keyword: String) async throws -> [Area]
}

public enum SearchAreasUseCaseKey: DependencyKey {
  public static var liveValue: SearchAreasUseCase {
    @Dependency(\.areasRepository) var areasRepository

    return SearchAreasUseCase { keyword in
      try await areasRepository.searchAreas(keyword: keyword)
    }
  }
}

extension DependencyValues {
  public var searchAreasUseCase: SearchAreasUseCase {
    get { self[SearchAreasUseCaseKey.self] }
    set { self[SearchAreasUseCaseKey.self] = newValue }
  }
}
