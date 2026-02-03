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
    case splashComplete
    case delegate(Delegate)
    
    public enum Delegate {
      case presentMainFeature
    }
  }
  
  @Dependency(\.continuousClock) var clock
  
  enum CancelID { case timer }
  
  public init() { }
  
  public var body: some ReducerOf<SplashFeature> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { [duration = state.splashDuration] send in
          for await _ in self.clock.timer(interval: .seconds(duration)) {
            await send(.splashComplete)
          }
        }
        .cancellable(id: CancelID.timer)
      case .splashComplete:
        return .concatenate(
          .cancel(id: CancelID.timer),
          .send(.delegate(.presentMainFeature))
        )
      case .delegate:
        return .none
      }
    }
  }
}
