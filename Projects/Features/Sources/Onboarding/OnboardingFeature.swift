//
//  OnboardingFeature.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import ComposableArchitecture
import Dependencies
import Domain
import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import Common

@Reducer
public struct OnboardingFeature {
  @ObservableState
  public struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    public init() {}
  }

  public enum Action: Hashable {
    case alert(PresentationAction<Alert>)
    case notifyByAlert(title: String, message: String)
    case loginStart(provider: SignInProvider)
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case loginCompleted(LoginType)
    }

    public enum Alert: Hashable {
    }

    public enum LoginType: Hashable {
      case notRegistered
      case customer
      case photographer
    }
  }

  public init() {}

  @Dependency(\.signInUseCase) private var signInUseCase: SignInUseCase

  public var body: some ReducerOf<OnboardingFeature> {
    Reduce { state, action in
      switch action {
      case .alert:
        return .none
      case let .notifyByAlert(title, message):
        state.alert = AlertState(title: {
          TextState(title)
        }, message: {
          TextState(message)
        })
        return .none
      case let .loginStart(provider):
        return handleLoginStart(provider: provider)
      case .delegate:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
  
  private let logger = PicLogger(category: "OnboardingFeature")
}

extension OnboardingFeature {
  private func handleLoginStart(provider: SignInProvider) -> Effect<Action> {
    return .run { send in
      if provider == .apple {
        await send(
          .notifyByAlert(title: "", message: "Apple 로그인 미구현")
        )
      } else if provider == .kakao {
        do {
          let kakaoAccessToken = try await startKakaoLogin()
          let signInResult = try await signInUseCase.execute(kakaoAccessToken)
          if signInResult.isRegistered {
            await send(.delegate(.loginCompleted(.customer)))
          } else {
            await send(.delegate(.loginCompleted(.notRegistered)))
          }
        } catch let kakaoError as KakaoSDKCommon.SdkError {
          switch kakaoError {
          case .ClientFailed(reason: let reason, errorMessage: _):
            if reason == .Cancelled {
              await send(
                .notifyByAlert(
                  title: "",
                  message: "사용자에 의해 카카오 로그인이 취소되었습니다. 다시 시도해주세요."
                )
              )
            }
          default:
            logger.error(
              "Error occurred during kakao signing in: \(kakaoError)"
            )
            await send(
              .notifyByAlert(
                title: "카카오 로그인 중 문제가 발생했습니다.",
                message: "문제가 계속되면 고객센터로 문의해주세요."
              )
            )
          }
        } catch {
          logger.error("Error occurred during signing in: \(error)")
          await send(
            .notifyByAlert(
              title: "예상하지 못한 문제가 발생했습니다.",
              message: "문제가 계속되면 고객센터로 문의해주세요."
            )
          )
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

extension OnboardingFeature {
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
