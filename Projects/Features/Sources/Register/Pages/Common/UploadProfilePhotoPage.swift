//
//  UploadProfilePhotoPage.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import Common
import Domain
import PhotosUI
import SwiftUI

struct UploadProfilePhotoPage: View {
  let userNickname: String

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 66
  let titleBottomSpacing: CGFloat = 30

  @State private var selectedImage: UIImage? = nil
  @State private var errorMessage: String? = nil
  private var nextButtonTitle: String {
    selectedImage == nil ? "다음에 설정하기" : "다음"
  }

  var body: some View {
    VStack(spacing: 0) {
      Text("안녕하세요 \(userNickname)님!")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, titleTopSpacing)
        .padding(.bottom, titleBottomSpacing)

      ProfilePhotosPicker(
        didImageSelected: { image in
          selectedImage = image
        },
        didErrorOccured: { error in
          errorMessage = "이미지를 불러오던 중 오류가 발생했습니다. 다시 시도해주세요."
          PicLogger(category: "UploadProfilePhotoPage").error(
            "error during getting image: \(error)"
          )
        }
      )
      .padding(.bottom, 70)

      Text("프로필 이미지를\n설정해주세요.")
        .typo(.pTitle)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, alignment: .center)

      Spacer()

      Button1(title: nextButtonTitle) {
        //
      }
    }
    .alert(
      errorMessage ?? "",
      isPresented: Binding(
        get: {
          errorMessage != nil
        },
        set: { present in
          if !present {
            errorMessage = nil
          }
        }
      )
    ) {}
    .padding(.horizontal)
    .navigationTitle("프로필 이미지 업로드")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  UploadProfilePhotoPage(userNickname: "유가영")
}
