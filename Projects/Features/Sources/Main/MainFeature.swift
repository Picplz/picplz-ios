//
//  MainFeature.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct MainFeature {
  @ObservableState
  public struct State: Equatable {
    var isLogin: Bool = false
    
    public init() { }
  }
  
  public enum Action {
    case loginComplete
  }
  
  public init() { }
  
  public var body: some ReducerOf<MainFeature> {
    Reduce { state, action in
      switch action {
      case .loginComplete:
        state.isLogin = true
        return .none
      }
    }
  }
}
