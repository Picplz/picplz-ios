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
    public init() { }
  }
  
  public enum Action {
  }
  
  public init() { }
  
  public var body: some ReducerOf<MainFeature> {
    Reduce { state, action in
      return .none
    }
  }
}
