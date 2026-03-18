//
//  CreatePhotographerUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/18/26.
//

import Dependencies
import Foundation

public struct CreatePhotographerUseCase {
  public var execute: (_ request: RegisterRequest, _ extra: PhotographerRegisterRequestExtra) async throws -> Bool
}

public enum CreatePhotographerUseCaseKey: DependencyKey {
  public static var liveValue: CreatePhotographerUseCase {
    @Dependency(\.membersRepository) var membersRepository

    return CreatePhotographerUseCase { request, extra in
      try await membersRepository.createPhotographer(request: request, extra: extra)
      return true
    }
  }
}

extension DependencyValues {
  public var createPhotographerUseCase: CreatePhotographerUseCase {
    get { self[CreatePhotographerUseCaseKey.self] }
    set { self[CreatePhotographerUseCaseKey.self] = newValue }
  }
}
