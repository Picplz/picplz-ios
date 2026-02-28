//
//  PhotographerFeature.swift
//  Features
//
//  Created by 임영택 on 2/28/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct PhotographerFeature {
  @ObservableState
  public struct State: Equatable {
    
    public init() { }
  }
  
  public enum Action: Hashable {
    
  }
  
  public init() { }
  
  public var body: some ReducerOf<PhotographerFeature> {
    Reduce { state, action in
      return .none
    }
  }
}
