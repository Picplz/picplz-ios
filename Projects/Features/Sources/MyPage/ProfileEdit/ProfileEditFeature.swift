//
//  ProfileEditFeature.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import ComposableArchitecture
import Domain
import Foundation
import UIKit

@Reducer
public struct ProfileEditFeature {
    /// 자기소개 최대 글자 수
    public static let maxBioLength: Int = 100

    @Dependency(\.photoLibraryPermissionManagerService) var photoPermissionManager
    @Dependency(\.openURL) var openURL
    @Dependency(\.validateNicknameUseCase) var validateNicknameUseCase

    @ObservableState
    public struct State: Equatable, Hashable {
        // 공통
        var nickname: String = ""

        // 닉네임 검증 상태 (nil이면 기본 헬퍼 텍스트 노출, 값이 있으면 에러 메시지 노출)
        var nicknameErrorMessage: String? = nil

        // 작가 모드 전용
        var isPhotographer: Bool = false
        var instagramUsername: String = ""
        var bio: String = ""

        // 사진 접근 권한 거부 시 표시되는 상태
        var isPhotoPermissionDenied: Bool = false

        public init(
            nickname: String = "",
            isPhotographer: Bool = false,
            instagramUsername: String = "",
            bio: String = "",
            isPhotoPermissionDenied: Bool = false
        ) {
            self.nickname = nickname
            self.isPhotographer = isPhotographer
            self.instagramUsername = instagramUsername
            self.bio = bio
            self.isPhotoPermissionDenied = isPhotoPermissionDenied
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case profileImageTapped                             // 프로필 사진 편집 버튼 탭
        case photoLibraryAccessResolved(PhotoLibraryAuthStatus) // 권한 체크/요청 결과
        case openPhotoSettingsTapped                         // 권한 거부 화면에서 설정 앱 이동
        case completeButtonTapped                            // 완료 버튼 탭 (닉네임 검증 시작)
        case nicknameValidationSucceeded                     // 닉네임 검증 통과
        case nicknameValidationFailed(String)                // 닉네임 검증 실패 (에러 메시지)
    }

    public init() {}

    public var body: some ReducerOf<ProfileEditFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.bio):
                // 자기소개 100자 제한 (한글/이모지 포함 count 기준)
                if state.bio.count > Self.maxBioLength {
                    state.bio = String(state.bio.prefix(Self.maxBioLength))
                }
                return .none

            case .binding(\.nickname):
                // 닉네임을 다시 수정하면 이전 에러 메시지 초기화
                state.nicknameErrorMessage = nil
                return .none

            case .binding:
                return .none

            case .backButtonTapped:
                return .none

            case .profileImageTapped:
                // 현재 권한 상태 → 필요 시 요청 → 결과 dispatch
                return .run { [manager = photoPermissionManager] send in
                    let current = manager.currentStatus()
                    if current == .notDetermined {
                        let requested = await manager.requestAuthorization()
                        await send(.photoLibraryAccessResolved(requested))
                    } else {
                        await send(.photoLibraryAccessResolved(current))
                    }
                }

            case let .photoLibraryAccessResolved(status):
                if status.isAccessible {
                    state.isPhotoPermissionDenied = false
                    // TODO: 갤러리 피커 present
                } else {
                    state.isPhotoPermissionDenied = true
                }
                return .none

            case .openPhotoSettingsTapped:
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return .none
                }
                return .run { _ in
                    await openURL(url)
                }

            case .completeButtonTapped:
                // 닉네임 검증 → 통과 시 프로필 수정 API 호출(TODO)
                let nickname = state.nickname
                return .run { [validate = validateNicknameUseCase] send in
                    do {
                        try await validate.execute(nickname)
                        await send(.nicknameValidationSucceeded)
                    } catch {
                        let message = (error as? LocalizedError)?.errorDescription
                            ?? error.localizedDescription
                        await send(.nicknameValidationFailed(message))
                    }
                }

            case .nicknameValidationSucceeded:
                state.nicknameErrorMessage = nil
                // TODO: 프로필 수정 API 연동
                return .none

            case let .nicknameValidationFailed(message):
                state.nicknameErrorMessage = message
                return .none
            }
        }
    }
}
