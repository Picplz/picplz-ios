//
//  MainFeature.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import Common
import ComposableArchitecture
import Domain
import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import Dependencies

@Reducer
public struct MainFeature {
  @ObservableState
  public struct State: Equatable {
    var isLogin: Bool = false
    
    @Presents var alert: AlertState<Action.Alert>?
    
    public init() {}
  }

  public enum Action: Hashable {
    case alert(PresentationAction<Alert>)
    case loginComplete
    case loginStart(provider: SignInProvider)
    case registerStart
    case notifyByAlert(title: String, message: String)
    
    public enum Alert: Hashable {
    }
  }

  public enum LoginProvider {
    case kakao
    case apple
  }

  public init() {}
  
  @Dependency(\.signInUseCase) private var signInUseCase: SignInUseCase

  public var body: some ReducerOf<MainFeature> {
    Reduce { state, action in
      switch action {
      case .alert:
        return .none
      case .loginComplete:
        state.isLogin = true
        return .none
      case let .loginStart(provider):
        return handleLoginStart(provider: provider)
      case .registerStart:
        return .none
      case let .notifyByAlert(title, message):
        state.alert = AlertState(title: {
          TextState(title)
        }, message: {
          TextState(message)
        })
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
  
  private let logger = PicLogger(category: "MainFeature")
}

extension MainFeature {
  private func handleLoginStart(provider: SignInProvider) -> Effect<Action> {
    return .run { send in
      if provider == .apple {
        await send(.notifyByAlert(title: "", message: "Apple 로그인은 아직 구현되지 않아 스킵합니다"))
      } else if provider == .kakao {
        do {
          let kakaoAccessToken = try await startKakaoLogin()
          let signInResult = try await signInUseCase.execute(kakaoAccessToken)
          if signInResult.isRegistered {
            await send(.loginComplete)
          } else {
            await send(.notifyByAlert(title: "", message: "회원가입이 필요합니다"))
          }
        } catch let kakaoError as KakaoSDKCommon.SdkError {
          switch kakaoError {
          case let .ClientFailed(reason: reason, errorMessage: _):
            if reason == .Cancelled {
              await send(.notifyByAlert(title: "", message: "사용자에 의해 카카오 로그인이 취소되었습니다. 다시 시도해주세요."))
            }
          default:
            logger.error("Error occurred during kakao signing in: \(kakaoError)")
            await send(.notifyByAlert(title: "카카오 로그인 중 문제가 발생했습니다.", message: "문제가 계속되면 고객센터로 문의해주세요."))
          }
        } catch {
          logger.error("Error occurred during signing in: \(error)")
          await send(.notifyByAlert(title: "예상하지 못한 문제가 발생했습니다.", message: "문제가 계속되면 고객센터로 문의해주세요."))
        }
      }
    }
  }

  private func startKakaoLogin() async throws -> KakaoAccessToken {
    return try await withCheckedThrowingContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
          if let error = error {
            continuation.resume(throwing: error)
          } else if let accessToken = oauthToken?.accessToken {
            continuation.resume(returning: accessToken)
          } else {
            continuation.resume(throwing: CustomError.accessTokenIsNil)
          }
        }
      } else {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
          if let error = error {
            continuation.resume(throwing: error)
          } else if let accessToken = oauthToken?.accessToken {
            continuation.resume(returning: accessToken)
          } else {
            continuation.resume(throwing: CustomError.accessTokenIsNil)
          }
        }
      }
    }
  }
}

extension MainFeature {
  enum CustomError: LocalizedError {
    case accessTokenIsNil
    
    var errorDescription: String? {
      switch self {
      case .accessTokenIsNil:
        return "Access token is nil"
      }
    }
  }
}
