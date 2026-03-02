//
//  TokenStorageProtocol.swift
//  Domain
//
//  Created by 임영택 on 2/28/26.
//

import Foundation
import Dependencies

public protocol TokenStorageProtocol {
  func saveAccessToken(_ token: PicplzAuthToken) throws
  func saveRefreshToken(_ token: PicplzAuthToken) throws
  func getAccessToken() -> PicplzAuthToken?
  func getRefreshToken() -> PicplzAuthToken?
  func deleteTokens() throws
}

public enum TokenStorageKey: DependencyKey {
  public static var liveValue: TokenStorageProtocol = UnimplementedTokenStorage()
}

public extension DependencyValues {
  var tokenStorage: TokenStorageProtocol {
    get { self[TokenStorageKey.self] }
    set { self[TokenStorageKey.self] = newValue }
  }
}

struct UnimplementedTokenStorage: TokenStorageProtocol {
  func saveAccessToken(_ token: PicplzAuthToken) throws {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func saveRefreshToken(_ token: PicplzAuthToken) throws {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func getAccessToken() -> PicplzAuthToken? {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func getRefreshToken() -> PicplzAuthToken? {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
  
  func deleteTokens() throws {
    fatalError("구현되지 않은 메서드를 호출했습니다")
  }
}
 
