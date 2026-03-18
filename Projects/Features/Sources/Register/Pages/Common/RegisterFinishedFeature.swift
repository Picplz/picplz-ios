//
//  RegisterFinishedFeature.swift
//  Features
//
//  Created by 임영택 on 3/9/26.
//

import Common
import ComposableArchitecture
import Domain
import Foundation
import SwiftUI

@Reducer
public struct RegisterFinishedFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    let userNickname: String
  }

  public enum Action: Hashable {
    case nextButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case completed
    }
  }

  public init() {}

  public var body: some ReducerOf<RegisterFinishedFeature> {
    Reduce { state, action in
      switch action {
      case .nextButtonTapped:
        return .send(
          .delegate(
            .completed
          )
        )
      case .delegate:
        return .none
      }
    }
  }
}
