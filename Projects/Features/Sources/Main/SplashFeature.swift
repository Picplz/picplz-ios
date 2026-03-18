//
//  SplashFeature.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import Common
import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct SplashFeature {
  @ObservableState
  public struct State: Equatable {
    let splashDuration: TimeInterval = 1

    public init() {}
  }

  public enum Action {
    case onAppear
    case splashComplete(InitialData)
    case delegate(Delegate)

    public enum Delegate {
      case dataLoaded(InitialData)
    }

    public struct InitialData {
      public let memberInfo: MemberInfo?

      init(memberInfo: MemberInfo?) {
        self.memberInfo = memberInfo
      }
    }
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.getTokensUseCase) var getTokensUseCase
  @Dependency(\.getMemberInfoUseCase) var getMemberInfoUseCase

  enum CancelID { case timer }

  public init() {}

  public var body: some ReducerOf<SplashFeature> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { [duration = state.splashDuration] send in
          async let memberInfo: MemberInfo? = {
            guard
              let memberId = getTokensUseCase.execute()?.userId,
              let memberIdInteger = Int(memberId)
            else { return nil }

            do {
              let memberInfo = try await getMemberInfoUseCase.execute(memberIdInteger)
              logger.info("스플래시에서 유저 정보를 불러옴: \(String(describing: memberInfo))")
              return memberInfo
            } catch {
              logger.error("유저 정보를 불러오는 중 오류 발생: \(error.localizedDescription)")
              return nil
            }
          }()

          async let _ = clock.sleep(for: .seconds(duration)) // 병렬 진행

          await send(.splashComplete(.init(memberInfo: memberInfo)))
        }
        .cancellable(id: CancelID.timer)
      case .splashComplete(let loadedData):
        return .concatenate(
          .cancel(id: CancelID.timer),
          .send(.delegate(.dataLoaded(loadedData)))
        )
      case .delegate:
        return .none
      }
    }
  }

  private let logger = PicLogger(category: "OnboardingFeature")
}
