//
//  RegisterFeature.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct RegisterFeature {
  @ObservableState
  public struct State: Equatable {
    
    public init() { }
  }
  
  public enum Action: Hashable {
    
  }
  
  public init() { }
  
  public var body: some ReducerOf<RegisterFeature> {
    Reduce { state, action in
      return .none
    }
  }
}
