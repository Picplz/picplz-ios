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
    var registerRequest: RegisterRequest
    var photographerRegisterRequest: PhotographerRegisterRequestExtra?

    var selectType = SelectTypeFeature.State()
    var path = StackState<Path.State>()

    public init(
      socialInfo: SocialInfo
    ) {
      registerRequest = RegisterRequest(
        nickname: "",
        socialInfo: socialInfo,
        profileImage: nil
      )
    }
  }

  public enum Action: Hashable {
    case selectType(SelectTypeFeature.Action)
    case path(StackAction<Path.State, Path.Action>)
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case registerCompleted
    }
  }

  public init() {}

  public var body: some ReducerOf<RegisterFeature> {
    Scope(state: \.selectType, action: \.selectType) {
      SelectTypeFeature()
    }

    Reduce {
      state,
      action in
      switch action {
      case .selectType(.delegate(.roleSelected(let role))):
        // 역할 선택 완료
        guard role != nil else { return .none }
        
        if role == .photographer {
          state.photographerRegisterRequest = PhotographerRegisterRequestExtra(
            photoMoods: [],
            activeAreas: [],
            cameras: []
          )
        }
        
        state.path.append(.inputNickname(InputNicknameFeature.State()))
        return .none
      case .selectType:
        return .none
      case .path(.element(id: _, action: .inputNickname(.delegate(.completed(let nickname))))):
        // 닉네임 입력 완료
        state.registerRequest.nickname = nickname
        state.path.append(
          .uploadProfileImage(
            UploadProfilePhotoFeature.State(userNickname: nickname)
          )
        )
        return .none
      case let .path(.element(id: _, action: .uploadProfileImage(.delegate(.completed(uploadResult))))):
        // 프로필 이미지 선택 완료
        state.registerRequest.profileImage = uploadResult?.objectKey
        
        if state.photographerRegisterRequest != nil { // 고객 정보 입력 완료
          // TODO: 고객 회원 가입 요청 전송
          return .send(.delegate(.registerCompleted))
        }
        
        // 작가 정보 입력 추가 진행
        
        return .none
      case .path:
        return .none
      case .delegate:
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
