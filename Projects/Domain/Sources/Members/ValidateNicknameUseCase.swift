//
//  ValidateNicknameUseCase.swift
//  Domain
//
//  Created by 임영택 on 3/2/26.
//

import Dependencies
import Foundation

public struct ValidateNicknameUseCase {
  public var execute: (_ nickname: String) async throws -> Void

  public static func live(membersRepository: any MembersRepositoryProtocol) -> Self {
    Self { nickname in
      if nickname.contains(" ") {
        throw ValidateNicknameError.notAllowedWhiteSpaces
      }

      // 2. 글자 수 제한 확인 (2~15자)
      let count = nickname.count
      if count < 2 || count > 15 {
        throw ValidateNicknameError.notAllowedRange
      }

      // 3. 허용된 문자(한글, 영문, 숫자) 확인
      let pattern = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]+$"
      if nickname.range(of: pattern, options: .regularExpression) == nil {
        throw ValidateNicknameError.notAllowedCharaters
      }
      
      // 4. 중복 확인
      let checkResult: Bool
      do {
        checkResult = try await membersRepository.checkAllowable(nickname: nickname)
      } catch {
        throw ValidateNicknameError.serverError
      }
      
      if !checkResult {
        throw ValidateNicknameError.duplicatedNickname
      }
    }
  }

  public static var test: Self {
    Self { _ in }
  }
}

public enum ValidateNicknameError: LocalizedError {
  case notAllowedCharaters
  case notAllowedRange
  case duplicatedNickname
  case notAllowedWhiteSpaces
  case serverError

  public var errorDescription: String? {
    switch self {
    case .notAllowedCharaters: "한글,영문,숫자만 입력해 주세요. (2~15자)"
    case .notAllowedRange: "한글,영문,숫자만 입력해 주세요. (2~15자)"
    case .duplicatedNickname: "중복된 닉네임입니다."
    case .notAllowedWhiteSpaces: "닉네임에 공백 사용은 불가능합니다."
    case .serverError: "서버 오류가 발생했습니다. 다시 시도해주세요."
    }
  }
}

public enum ValidateNicknameUseCaseKey: TestDependencyKey {
  public static var testValue: ValidateNicknameUseCase = .test
}

extension DependencyValues {
  public var validateNicknameUseCase: ValidateNicknameUseCase {
    get { self[ValidateNicknameUseCaseKey.self] }
    set { self[ValidateNicknameUseCaseKey.self] = newValue }
  }
}
