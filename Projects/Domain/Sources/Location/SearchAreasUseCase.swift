//
//  SearchAreasUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/17/26.
//

import Dependencies

public struct SearchAreasUseCase {
  public var execute: (_ keyword: String) async throws -> [Area]

  public static func live(areasRepository: any AreasRepositoryProtocol) -> Self {
    Self { keyword in
      try await areasRepository.searchAreas(keyword: keyword)
    }
  }

  public static var test: Self {
    Self { _ in [] }
  }
}

public enum SearchAreasUseCaseKey: TestDependencyKey {
  public static var testValue: SearchAreasUseCase = .test
}

extension DependencyValues {
  public var searchAreasUseCase: SearchAreasUseCase {
    get { self[SearchAreasUseCaseKey.self] }
    set { self[SearchAreasUseCaseKey.self] = newValue }
  }
}
