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
}

public enum GetMemberInfoUseCaseKey: DependencyKey {
  public static var liveValue: GetMemberInfoUseCase {
    @Dependency(\.membersRepository) var membersRepository

    return GetMemberInfoUseCase { memberId in
      return try await membersRepository.getInfo(memberId: memberId)
    }
  }
}

extension DependencyValues {
  public var getMemberInfoUseCase: GetMemberInfoUseCase {
    get { self[GetMemberInfoUseCaseKey.self] }
    set { self[GetMemberInfoUseCaseKey.self] = newValue }
  }
}
