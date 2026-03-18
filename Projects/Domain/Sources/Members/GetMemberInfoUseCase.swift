//
//  GetMemberInfoUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies
import Foundation
import SwiftUI

public struct GetMemberInfoUseCase {
  public var execute: (_ memberId: Int) async throws -> MemberInfo?

  public static func live(membersRepository: any MembersRepositoryProtocol) -> Self {
    Self { memberId in
      return try await membersRepository.getInfo(memberId: memberId)
    }
  }

  public static var test: Self {
    Self { _ in nil }
  }
}

public enum GetMemberInfoUseCaseKey: TestDependencyKey {
  public static var testValue: GetMemberInfoUseCase = .test
}

extension DependencyValues {
  public var getMemberInfoUseCase: GetMemberInfoUseCase {
    get { self[GetMemberInfoUseCaseKey.self] }
    set { self[GetMemberInfoUseCaseKey.self] = newValue }
  }
}
