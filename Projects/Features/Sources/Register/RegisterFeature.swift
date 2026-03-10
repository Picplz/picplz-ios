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
    var registerFinished: RegisterFinishedFeature.State?
    var path = StackState<Path.State>()
    
    var toastItem: ToastItem?

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
    case registerFinished(RegisterFinishedFeature.Action)
    case path(StackAction<Path.State, Path.Action>)
    case registerResponse(TaskResult<Bool>)
    case toastItemChanged(ToastItem?)
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case registerCompleted
    }
  }

  public init() {}
  
  @Dependency(\.createCustomerUseCase) var createCustomerUseCase

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
        } else {
          state.photographerRegisterRequest = nil
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
        
        if state.photographerRegisterRequest == nil { // 고객 정보 입력 완료
          return .run { [registerRequest = state.registerRequest] send in
            await send(.registerResponse(TaskResult {
              return try await createCustomerUseCase.execute(registerRequest)
            }))
          }
        }
        
        // 작가 정보 입력 추가 진행
        
        return .none
      case .path:
        return .none
      case .registerFinished:
        return .none
      case .registerResponse(.success):
        state.registerFinished = RegisterFinishedFeature.State(
          userNickname: state.registerRequest.nickname
        )
        state.path = StackState<Path.State>()
        return .none
      case let .registerResponse(.failure(error)):
        state.toastItem = ToastItem(message: "회원가입 도중 에러가 발생했습니다. 에러가 반복되면 문의해주세요. \(error.localizedDescription)")
        return .none
      case let .toastItemChanged(toastItem):
        state.toastItem = toastItem
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
