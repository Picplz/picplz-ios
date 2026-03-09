//
//  SelectTypeFeature.swift
//  Features
//
//  Created by 임영택 on 3/9/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct SelectTypeFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    var selectedRole: Role?
  }
  
  public enum Action: Hashable {
    case roleChanged(Role?)
    case nextButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case roleSelected(Role?)
    }
  }
  
  public init() { }
  
  public var body: some ReducerOf<SelectTypeFeature> {
    Reduce { state, action in
      switch action {
      case let .roleChanged(role):
        state.selectedRole = role
        return .none
      case .nextButtonTapped:
        guard let role = state.selectedRole else { return .none }
        return .send(.delegate(.roleSelected(role)))
      case .delegate:
        return .none
      }
    }
  }
}
