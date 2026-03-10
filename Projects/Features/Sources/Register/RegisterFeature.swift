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
    var selectType = SelectTypeFeature.State()
    var path = StackState<Path.State>()
    
    public init() { }
  }

  public enum Action: Hashable {
    case selectType(SelectTypeFeature.Action)
    case path(StackAction<Path.State, Path.Action>)
  }

  public init() {}

  public var body: some ReducerOf<RegisterFeature> {
    Scope(state: \.selectType, action: \.selectType) {
      SelectTypeFeature()
    }

    Reduce { state, action in
      switch action {
      case .selectType(.delegate(.roleSelected(let role))):
        guard role != nil else { return .none }
        state.path.append(.inputNickname(InputNicknameFeature.State()))
        return .none
      case .selectType:
        return .none
      case let .path(.element(id: _, action: .inputNickname(.delegate(.completed(nickname))))):
        state.path.append(.uploadProfileImage(UploadProfilePhotoFeature.State(userNickname: nickname)))
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
  }

  @Reducer
  public struct Path {
    @ObservableState
    public enum State: Equatable, Hashable {
      // MARK: - 공통 페이지
      case inputNickname(InputNicknameFeature.State)
      case uploadProfileImage(UploadProfilePhotoFeature.State)
      //    case registerFinished
      //
      //    // MARK: - 작가 가입용 페이지
      //    case requestLocationPermission
      //    case selectPrimaryArea
      //    case InputEquipments
      //    case addNewPhone
      //    case addNewCamera
      //    case inputConcepts
    }

    public enum Action: Hashable {
      case inputNickname(InputNicknameFeature.Action)
      case uploadProfileImage(UploadProfilePhotoFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Path> {
      Scope(state: \.inputNickname, action: \.inputNickname) {
        InputNicknameFeature()
      }
      Scope(state: \.uploadProfileImage, action: \.uploadProfileImage) {
        UploadProfilePhotoFeature()
      }
    }
  }
}
