//
//  SplashFeature.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct SplashFeature {
  @ObservableState
  public struct State: Equatable {
    let splashDuration: TimeInterval = 1
    
    public init() { }
  }
  
  public enum Action {
    case onAppear
    case splashComplete(InitialData)
    case delegate(Delegate)
    
    public enum Delegate {
      case dataLoaded(InitialData)
    }
    
    public struct InitialData {
      public let tokens: PicplzTokens?
    }
  }
  
  @Dependency(\.continuousClock) var clock
  @Dependency(\.getTokensUseCase) var getTokensUseCase
  
  enum CancelID { case timer }
  
  public init() { }
  
  public var body: some ReducerOf<SplashFeature> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { [duration = state.splashDuration] send in
          let tokens = getTokensUseCase.execute()
          
          for await _ in self.clock.timer(interval: .seconds(duration)) {
            await send(.splashComplete(.init(tokens: tokens)))
          }
        }
        .cancellable(id: CancelID.timer)
      case let .splashComplete(loadedData):
        return .concatenate(
          .cancel(id: CancelID.timer),
          .send(.delegate(.dataLoaded(loadedData)))
        )
      case .delegate:
        return .none
      }
    }
  }
}
