//
//  UploadProfilePhotoPage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import ComposableArchitecture
import Common
import Domain
import PhotosUI
import SwiftUI

struct UploadProfilePhotoPage: View {
  @Bindable var store: StoreOf<UploadProfilePhotoFeature>
  
  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 66
  let titleBottomSpacing: CGFloat = 30
  
  private var nextButtonTitle: String {
    store.selectedProfileImage == nil ? "다음에 설정하기" : "다음"
  }

  var body: some View {
    VStack(spacing: 0) {
      Text("안녕하세요 \(store.userNickname)님!")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, titleTopSpacing)
        .padding(.bottom, titleBottomSpacing)

      ProfilePhotosPicker(
        didImageSelected: { image in
          store.send(.profileImageSelected(image))
        },
        didErrorOccured: { error in
          store.send(.selectImageFromPhotosFailed(error.localizedDescription))
        }
      )
      .padding(.bottom, 70)

      Text("프로필 이미지를\n설정해주세요.")
        .typo(.pTitle)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, alignment: .center)

      Spacer()

      Button1(title: nextButtonTitle) {
        store.send(.nextButtonTapped)
      }
    }
    .alert($store.scope(state: \.alert, action: \.alert))
    .padding(.horizontal)
    .navigationTitle("프로필 이미지 업로드")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  struct PreviewS3Repository: S3RepositoryProtocol {
    func getPresignedUploadURL(filename: String, fileType: Domain.S3FileType) async throws -> (Domain.S3PresignedURL, Domain.S3ObjectKey) {
      throw NSError(domain: "프리뷰 환경 오류", code: -1)
    }
    
    func uploadJPEGFile(jpegData: Data, to presignedURL: URL) async throws {
      throw NSError(domain: "프리뷰 환경 오류", code: -1)
    }
  }
  S3RepositoryKey.liveValue = PreviewS3Repository()
  
  return UploadProfilePhotoPage(store: Store(initialState: UploadProfilePhotoFeature.State(userNickname: "유가영")) {
    UploadProfilePhotoFeature()
      ._printChanges()
  })
}
