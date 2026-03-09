//
//  InputNicknameFeature.swift
//  Features
//
//  Created by 임영택 on 3/9/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct InputNicknameFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    var inputNickname: String = ""
    var isValid: Bool = true
    var errorMessage: String = ""
  }
  
  public enum Action: Hashable {
    case textChanged(String)
    case validationSuccess
    case validationFailed(String)
    case nextButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case nicknameSubmitted(String)
    }
  }
  
  @Dependency(\.validateNicknameUseCase) private var validateNicknameUseCase
  
  init() { }
  
  public var body: some ReducerOf<InputNicknameFeature> {
    Reduce { state, action in
      switch action {
      case let .textChanged(nickname):
        state.inputNickname = nickname
        return .run { [nickname] send in
          do {
            try await validateNicknameUseCase.execute(nickname)
            await send(.validationSuccess)
          } catch {
            await send(.validationFailed(error.localizedDescription))
          }
        }
      case .validationSuccess:
        state.isValid = true
        state.errorMessage = ""
        return .none
      case let .validationFailed(errorMessage):
        state.isValid = false
        state.errorMessage = errorMessage
        return .none
      case .nextButtonTapped:
        return .send(.delegate(.nicknameSubmitted(state.inputNickname)))
      case .delegate:
        return .none
      }
    }
  }
}
