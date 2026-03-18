//
//  CreateCustomerUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies
import Foundation
import SwiftUI

public struct CreateCustomerUseCase {
  public var execute: (_ request: RegisterRequest) async throws -> Bool

  public static func live(membersRepository: any MembersRepositoryProtocol) -> Self {
    Self { request in
      try await membersRepository.createCustomer(request: request)
      return true
    }
  }

  public static var test: Self {
    Self { _ in true }
  }
}

public enum CreateCustomerUseCaseKey: TestDependencyKey {
  public static var testValue: CreateCustomerUseCase = .test
}

extension DependencyValues {
  public var createCustomerUseCase: CreateCustomerUseCase {
    get { self[CreateCustomerUseCaseKey.self] }
    set { self[CreateCustomerUseCaseKey.self] = newValue }
  }
}
