//
//  UploadProfilePhotoFeature.swift
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
public struct UploadProfilePhotoFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    let userNickname: String
    var selectedProfileImage: UIImage?
    var uploadedProfileImageObjectKey: String?
    @Presents var alert: AlertState<Action.Alert>?
  }

  public enum Action: Hashable {
    case profileImageSelected(UIImage)
    case nextButtonTapped
    case uploadResponse(TaskResult<String>)
    case selectImageFromPhotosFailed(String)
    case delegate(Delegate)
    case alert(PresentationAction<Alert>)

    public enum Delegate: Hashable {
      case completed(ProfileImageUploadResult?)
    }

    public enum Alert: Hashable {
    }
  }

  public init() {}

  @Dependency(\.profileImageUploadUseCase) var profileImageUploadUseCase

  public var body: some ReducerOf<UploadProfilePhotoFeature> {
    Reduce { state, action in
      switch action {
      case .profileImageSelected(let image):
        state.selectedProfileImage = image
        return .run { [image] send in
          await send(
            .uploadResponse(
              TaskResult { try await profileImageUploadUseCase.execute(image) }
            )
          )
        }
      case .nextButtonTapped:
        if let image = state.selectedProfileImage,
          let objectKey = state.uploadedProfileImageObjectKey
        {
          return .send(
            .delegate(
              .completed(
                ProfileImageUploadResult(image: image, objectKey: objectKey)
              )
            )
          )
        }

        return .send(.delegate(.completed(nil)))
      case .uploadResponse(.success(let objectKey)):
        logger.info("이미지 업로드 성공. ObjectKey: \(objectKey)")
        state.uploadedProfileImageObjectKey = objectKey
        return .none
      case .uploadResponse(.failure(let error)):
        logger.error("이미지 업로드 중 에러: \(error.localizedDescription)")
        state.selectedProfileImage = nil
        state.alert = AlertState(
          title: {
            TextState("프로필 이미지 업로드 중 문제가 발생했어요")
          },
          message: {
            TextState(error.localizedDescription)
          }
        )
        return .none
      case let .selectImageFromPhotosFailed(errorMessage):
        state.alert = AlertState(
          title: {
            TextState("이미지를 불러오는 도중 발생했어요")
          },
          message: {
            TextState(errorMessage)
          }
        )
        return .none
      case .delegate:
        return .none
      case .alert:
        return .none
      }
    }
  }

  public struct ProfileImageUploadResult: Hashable {
    public let image: UIImage
    public let objectKey: String
  }

  private let logger = PicLogger(category: "UploadProfilePhotoFeature")
}
