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
    var selectedRole: Role?

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
      case registerCompleted(Role)
    }
  }

  public init() {}
  
  @Dependency(\.createCustomerUseCase) var createCustomerUseCase
  @Dependency(\.createPhotographerUseCase) var createPhotographerUseCase

  public var body: some ReducerOf<RegisterFeature> {
    Scope(state: \.selectType, action: \.selectType) {
      SelectTypeFeature()
    }
    .ifLet(\.registerFinished, action: \.registerFinished) {
      RegisterFinishedFeature()
    }

    Reduce {
      state,
      action in
      switch action {
      case .selectType(.delegate(.roleSelected(let role))):
        // 역할 선택 완료
        guard role != nil else { return .none }
        
        state.selectedRole = role
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
        
        if state.selectedRole == .customer { // 고객 정보 입력 완료
          return .run { [registerRequest = state.registerRequest] send in
            await send(.registerResponse(TaskResult {
              return try await createCustomerUseCase.execute(registerRequest)
            }))
          }
        }
        
        if state.selectedRole == .photographer {
          // 작가 정보 입력 추가 진행
          state.path.append(.requestLocationPermission(RequestLocationPermissionFeature.State()))
        }
        
        return .none

      case .path(.element(id: _, action: .requestLocationPermission(.delegate(.completed)))):
        // 위치 권한 요청 완료
        state.path.append(.selectPrimaryArea(SelectPrimaryAreaFeature.State()))
        return .none
      case let .path(.element(id: _, action: .selectPrimaryArea(.delegate(.completed(areas))))):
        // 주 활동 지역 선택 완료
        state.photographerRegisterRequest?.activeAreas = areas
        
        let cameras = state.photographerRegisterRequest?.cameras ?? []
        let phones = cameras.filter { $0.type == .phone }
        let realCameras = cameras.filter {
          if case .camera = $0.type { return true }
          return false
        }
        
        state.path.append(.inputEquipments(InputEquipmentsFeature.State(
          selectedPhones: phones,
          selectedCameras: realCameras
        )))
        return .none

      case .path(.element(id: _, action: .inputEquipments(.delegate(.addPhone)))):
        state.path.append(.addNewPhone(AddNewPhoneFeature.State()))
        return .none

      case .path(.element(id: _, action: .inputEquipments(.delegate(.addCamera)))):
        state.path.append(.addNewCamera(AddNewCameraFeature.State()))
        return .none

      case let .path(.element(id: _, action: .inputEquipments(.delegate(.completed(equipments))))):
        // 장비 선택 완료
        state.photographerRegisterRequest?.cameras = equipments
        state.path.append(.inputConcepts(InputConceptsFeature.State()))
        return .none

      case let .path(.element(id: _, action: .inputConcepts(.delegate(.completed(moods))))):
        // 분위기 선택 완료
        state.photographerRegisterRequest?.photoMoods = moods
        
        guard let photographerRegisterRequest = state.photographerRegisterRequest else { return .none }
        
        // 작가 회원 가입
        return .run { [registerRequest = state.registerRequest, photographerRegisterRequest] send in
          await send(.registerResponse(TaskResult {
            return try await createPhotographerUseCase.execute(registerRequest, photographerRegisterRequest)
          }))
        }

      case let .path(.element(id: _, action: .addNewPhone(.delegate(.addEquipment(equipment))))):
        state.photographerRegisterRequest?.cameras.append(equipment)
        
        // InputEquipments 상태 동기화
        for id in state.path.ids {
          if case .inputEquipments = state.path[id: id] {
            state.path[id: id, case: \.inputEquipments]?.selectedPhones.append(equipment)
          }
        }
        
        _ = state.path.popLast()
        return .none

      case let .path(.element(id: _, action: .addNewCamera(.delegate(.addEquipment(equipment))))):
        state.photographerRegisterRequest?.cameras.append(equipment)
        
        // InputEquipments 상태 동기화
        for id in state.path.ids {
          if case .inputEquipments = state.path[id: id] {
            state.path[id: id, case: \.inputEquipments]?.selectedCameras.append(equipment)
          }
        }

        _ = state.path.popLast()
        return .none

      case .path:
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
      case .registerFinished(.delegate(.completed)):
        guard let selectedRole = state.selectedRole else { return .none }
        return .send(.delegate(.registerCompleted(selectedRole)))
      case .registerFinished:
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

      // MARK: - 작가 가입용 페이지
      case requestLocationPermission(RequestLocationPermissionFeature.State)
      case selectPrimaryArea(SelectPrimaryAreaFeature.State)
      case inputEquipments(InputEquipmentsFeature.State)
      case addNewPhone(AddNewPhoneFeature.State)
      case addNewCamera(AddNewCameraFeature.State)
      case inputConcepts(InputConceptsFeature.State)
    }

    public enum Action: Hashable {
      case inputNickname(InputNicknameFeature.Action)
      case uploadProfileImage(UploadProfilePhotoFeature.Action)
      case requestLocationPermission(RequestLocationPermissionFeature.Action)
      case selectPrimaryArea(SelectPrimaryAreaFeature.Action)
      case inputEquipments(InputEquipmentsFeature.Action)
      case addNewPhone(AddNewPhoneFeature.Action)
      case addNewCamera(AddNewCameraFeature.Action)
      case inputConcepts(InputConceptsFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Path> {
      Scope(state: \.inputNickname, action: \.inputNickname) {
        InputNicknameFeature()
      }
      Scope(state: \.uploadProfileImage, action: \.uploadProfileImage) {
        UploadProfilePhotoFeature()
      }
      Scope(state: \.requestLocationPermission, action: \.requestLocationPermission) {
        RequestLocationPermissionFeature()
      }
      Scope(state: \.selectPrimaryArea, action: \.selectPrimaryArea) {
        SelectPrimaryAreaFeature()
      }
      Scope(state: \.inputEquipments, action: \.inputEquipments) {
        InputEquipmentsFeature()
      }
      Scope(state: \.addNewPhone, action: \.addNewPhone) {
        AddNewPhoneFeature()
      }
      Scope(state: \.addNewCamera, action: \.addNewCamera) {
        AddNewCameraFeature()
      }
      Scope(state: \.inputConcepts, action: \.inputConcepts) {
        InputConceptsFeature()
      }
    }
  }
}
