//
//  MembersRepositoryProtocol.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies

public typealias IsAllowableNickname = Bool

public protocol MembersRepositoryProtocol {
  func checkAllowable(nickname: String) async throws -> IsAllowableNickname
  func getInfo(memberId: Int) async throws -> MemberInfo?
}

struct UnimplementedMembersRepository: MembersRepositoryProtocol {
  func checkAllowable(nickname: String) async throws -> IsAllowableNickname {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func getInfo(memberId: Int) async throws -> MemberInfo? {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}

public enum MembersRepositoryKey: DependencyKey {
  public static var liveValue: MembersRepositoryProtocol = UnimplementedMembersRepository()
}

public extension DependencyValues {
  var membersRepository: MembersRepositoryProtocol {
    get { self[MembersRepositoryKey.self] }
    set { self[MembersRepositoryKey.self] = newValue }
  }
}
