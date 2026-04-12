//
//  PhotographerPhotoDetailView.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import SwiftUI
import ComposableArchitecture

public struct PhotographerPhotoDetailView: View {
  let store: StoreOf<PhotographerPhotoDetailFeature>
  
  public init(store: StoreOf<PhotographerPhotoDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TempPicNavigationBar(title: "") {
        store.send(.backButtonTapped)
      }
      
      TabView(selection: Binding(
        get: { store.currentIndex },
        set: { store.send(.imagePaged($0)) }
      )) {
        ForEach(0..<store.images.count, id: \.self) { index in
          if let uiImage = UIImage(data: store.images[index]) {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFit()
              .tag(index)
          }
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .background(.pBlack)
      
      Spacer()
    }
    .background(.pBlack)
    .navigationBarHidden(true)
  }
}

#Preview {
  PhotographerPhotoDetailView(
    store: Store(initialState: PhotographerPhotoDetailFeature.State(
      images: [
        UIImage(resource: .sampleVertical1).jpegData(compressionQuality: 0.8)!,
        UIImage(resource: .sampleVertical2).jpegData(compressionQuality: 0.8)!
      ],
      currentIndex: 0
    )) {
      PhotographerPhotoDetailFeature()
    }
  )
}
