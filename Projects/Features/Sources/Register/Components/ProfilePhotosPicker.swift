//
//  ProfilePhotosPicker.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import PhotosUI
import SwiftUI

struct ProfilePhotosPicker: View {
  let imageSize: CGFloat = 160
  let didImageSelected: (_ image: UIImage) -> Void
  let didErrorOccured: (Error) -> Void

  @State private var selectedPhoto: PhotosPickerItem? = nil
  @State private var selectedUIImage: UIImage? = nil

  var body: some View {
    PhotosPicker(
      selection: $selectedPhoto,
      matching: .images
    ) {
      Group {
        if let selectedUIImage {
          Image(uiImage: selectedUIImage)
            .resizable()
            .scaledToFill()
        } else {
          Image(.profileImagePlaceholder)
            .resizable()
            .scaledToFill()
        }
      }
      .frame(width: imageSize, height: imageSize)
      .clipShape(.circle)
      .overlay(alignment: .bottomTrailing) {
        Image(.cameraCircle)
          .padding(4)
      }
    }
    .onChange(of: selectedPhoto) { _, newValue in
      handleSelectedPhoto(newValue)
    }
  }
}

extension ProfilePhotosPicker {
  private func handleSelectedPhoto(_ newPhoto: PhotosPickerItem?) {
    guard let newPhoto else { return }

    newPhoto.loadTransferable(type: Data.self) { result in
      switch result {
      case .success(let data):
        if let data = data, let newImage = UIImage(data: data) {
          DispatchQueue.main.async {
            selectedUIImage = newImage
            didImageSelected(newImage)
          }
        }
      case .failure(let failure):
        didErrorOccured(failure)
      }
    }

    selectedPhoto = nil
  }
}

#Preview {
  ProfilePhotosPicker { _ in
    //
  } didErrorOccured: { _ in
    //
  }
}
