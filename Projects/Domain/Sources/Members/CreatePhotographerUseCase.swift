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

  public static func live(membersRepository: any MembersRepositoryProtocol) -> Self {
    Self { request, extra in
      try await membersRepository.createPhotographer(request: request, extra: extra)
      return true
    }
  }

  public static var test: Self {
    Self { _, _ in true }
  }
}

public enum CreatePhotographerUseCaseKey: TestDependencyKey {
  public static var testValue: CreatePhotographerUseCase = .test
}

extension DependencyValues {
  public var createPhotographerUseCase: CreatePhotographerUseCase {
    get { self[CreatePhotographerUseCaseKey.self] }
    set { self[CreatePhotographerUseCaseKey.self] = newValue }
  }
}
