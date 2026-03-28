//
//  CustomerHomeView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import ComposableArchitecture

public struct CustomerHomeView: View {
  @Bindable var store: StoreOf<CustomerHomeFeature>
  
  public init(store: StoreOf<CustomerHomeFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      // Header Section
      VStack(spacing: 0) {
        HomeLocationHeader(
          location: store.location,
          onLocationTapped: { store.send(.locationTapped) },
          onNotificationTapped: { store.send(.notificationTapped) },
          onProfileTapped: { store.send(.profileTapped) }
        )
        
        TextField(
          "촬영을 하고 싶은 작가를 검색해보세요",
          text: $store.searchQuery,
          prompt: Text("촬영을 하고 싶은 작가를 검색해보세요").foregroundStyle(.pGrey3)
        )
        .pSearchTextField {
          store.send(.searchButtonTapped)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      }
      .background(.pWhite)
      
      // Feed Section
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(store.posts) { post in
            HomePostCard(
              authorName: post.authorName,
              authorLocation: post.authorLocation,
              postImagesData: post.postImagesData,
              postLocation: post.postLocation,
              postDate: post.postDate,
              onReportTapped: { store.send(.reportTapped(id: post.id)) }
            )
            .padding(.horizontal, 16)
          }
        }
      }
    }
    .background(.pWhite)
    .sheet(
      item: $store.scope(state: \.locationSelect, action: \.locationSelect)
    ) { locationSelectStore in
      LocationSelectView(store: locationSelectStore)
        .presentationDetents([.height(600)])
        .presentationDragIndicator(.visible)
    }
  }
}

#Preview {
  CustomerHomeView(
    store: Store(initialState: CustomerHomeFeature.State()) {
      CustomerHomeFeature()
    }
  )
}
