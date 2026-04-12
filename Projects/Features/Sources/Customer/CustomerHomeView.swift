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
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: 0) {
        // Header Section
        VStack(spacing: 0) {
          HomeLocationHeader(
            location: store.location,
            onLocationTapped: { store.send(.locationTapped) },
            onNotificationTapped: { store.send(.notificationTapped) },
            onProfileTapped: { store.send(.profileTapped) }
          )
          
          // Search Bar (기본 pSearchTextField 인터페이스 유지)
          Button(action: { store.send(.searchBarTapped) }) {
            TextField(
              "촬영을 하고 싶은 작가를 검색해보세요",
              text: .constant(""),
              prompt: Text("촬영을 하고 싶은 작가를 검색해보세요").foregroundStyle(.pGrey3)
            )
            .pSearchTextField {
              store.send(.searchBarTapped)
            }
            .disabled(true)
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
    } destination: { store in
      switch store.case {
      case let .searchPhotographers(searchStore):
        SearchPhotographersView(store: searchStore)
      case let .photographerDetail(detailStore):
        PhotographerDetailView(store: detailStore)
      case let .reviewList(reviewStore):
        PhotographerReviewListView(store: reviewStore)
      case let .photoReviewList(photoReviewStore):
        PhotographerPhotoReviewListView(store: photoReviewStore)
      case let .photoDetail(photoDetailStore):
        PhotographerPhotoDetailView(store: photoDetailStore)
      }
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
