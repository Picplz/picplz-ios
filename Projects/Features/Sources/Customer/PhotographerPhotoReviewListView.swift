//
//  PhotographerPhotoReviewListView.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import SwiftUI
import ComposableArchitecture

public struct PhotographerPhotoReviewListView: View {
  @Bindable var store: StoreOf<PhotographerPhotoReviewListFeature>
  
  public init(store: StoreOf<PhotographerPhotoReviewListFeature>) {
    self.store = store
  }
  
  private let columns = [
    GridItem(.flexible(), spacing: 2),
    GridItem(.flexible(), spacing: 2),
    GridItem(.flexible(), spacing: 2)
  ]
  
  public var body: some View {
    VStack(spacing: 0) {
      TempPicNavigationBar(title: "사진 리뷰") {
        store.send(.backButtonTapped)
      }
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 2) {
          ForEach(0..<store.photoReviews.count, id: \.self) { index in
            if let uiImage = UIImage(data: store.photoReviews[index]) {
              Button(action: { store.send(.imageTapped(index)) }) {
                Rectangle()
                  .fill(.pGrey1)
                  .overlay {
                    Image(uiImage: uiImage)
                      .resizable()
                      .scaledToFill()
                  }
                  .aspectRatio(1, contentMode: .fill)
                  .clipped()
              }
            }
          }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
      }
    }
    .background(.pWhite)
    .navigationBarHidden(true)
  }
}

#Preview {
  PhotographerPhotoReviewListView(
    store: Store(initialState: PhotographerPhotoReviewListFeature.State(
      photographerId: UUID(),
      photoReviews: [
        UIImage(resource: .sampleVertical1).jpegData(compressionQuality: 0.8)!,
        UIImage(resource: .sampleVertical2).jpegData(compressionQuality: 0.8)!,
        UIImage(resource: .sampleVertical1).jpegData(compressionQuality: 0.8)!,
        UIImage(resource: .sampleVertical2).jpegData(compressionQuality: 0.8)!,
        UIImage(resource: .sampleVertical1).jpegData(compressionQuality: 0.8)!,
        UIImage(resource: .sampleVertical2).jpegData(compressionQuality: 0.8)!
      ]
    )) {
      PhotographerPhotoReviewListFeature()
    }
  )
}
