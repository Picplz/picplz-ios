//
//  PhotographerReviewListView.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import ComposableArchitecture
import Domain
import SwiftUI

public struct PhotographerReviewListView: View {
  @Bindable var store: StoreOf<PhotographerReviewListFeature>

  public init(store: StoreOf<PhotographerReviewListFeature>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      // Header
      TempPicNavigationBar(title: "리뷰") {
        store.send(.backButtonTapped)
      }

      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          // Rating Summary Section
          VStack(alignment: .leading, spacing: 8) {
            Text("촬영 만족도")
              .typo(.pSmallTitle)
              .foregroundStyle(.pBlack)

            HStack(spacing: 4) {
              RatingView(rating: store.rating, starSize: 20, theme: .green)

              Text(String(format: "%.1f", store.rating))
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)
            }
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 20)

          // Review Images Section
          VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
              Text("리뷰")
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)
              Text("\(store.reviewCount)")
                .typo(.pParagraph)
                .foregroundStyle(.pBlack)
            }
            .padding(.horizontal, 16)

            if !store.topReviewImages.isEmpty {
              HStack(spacing: 1) {
                let images = Array(store.topReviewImages.prefix(4))
                let hasMore = store.topReviewImages.count >= 5

                ForEach(Array(images.enumerated()), id: \.offset) {
                  index,
                  data in
                  Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                      ZStack {
                        if let uiImage = UIImage(data: data) {
                          Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                        } else {
                          Color.gray.opacity(0.2)
                        }

                        if index == 3 && hasMore {
                          Color.black.opacity(0.4)
                            .overlay(
                              Text("+\(store.topReviewImages.count - 4)")
                                .typo(.pBoldParagraph)
                                .foregroundStyle(.pWhite)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                              store.send(.photoReviewButtonTapped)
                            }
                        }
                      }
                    }
                    .clipped()
                }
              }
              .padding(.horizontal, 16)
            }
          }
          .padding(.bottom, 20)

          // Section Divider
          Rectangle()
            .fill(.pGrey1)
            .frame(height: 10)

          // Sorting Dropdown
          HStack {
            Button(action: { store.send(.sortDropdownTapped) }) {
              HStack(spacing: 4) {
                Text(store.sortOrder.rawValue)
                  .typo(.pCaption)
                  .foregroundStyle(.pGrey5)

                Image(systemName: "chevron.down")
                  .font(.system(size: 8))
                  .foregroundStyle(.pGrey5)
              }
            }
            Spacer()
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 20)

          // Review List
          VStack(spacing: 20) {
            ForEach(store.reviews) { review in
              PhotographerReviewCard(
                review: review,
                onReport: { store.send(.reportButtonTapped(review.id)) },
                onLike: { store.send(.likeButtonTapped(review.id)) }
              )

              Divider()
                .background(.pGrey2)
                .padding(.horizontal, 16)
            }
          }
          .padding(.bottom, 40)
        }
      }
    }
    .background(.pWhite)
    .navigationBarHidden(true)
    .sheet(
      item: $store.scope(state: \.sortModal, action: \.sortModal)
    ) { sortStore in
      ReviewSortSelectView(store: sortStore)
        .presentationDetents([.height(240)])
        .presentationDragIndicator(.visible)
    }
  }
}

// MARK: - ReviewSortSelectView
struct ReviewSortSelectView: View {
  let store: StoreOf<PhotographerReviewListFeature.SortSelectFeature>

  var body: some View {
    VStack(spacing: 0) {
      Capsule()
        .fill(.pGrey2)
        .frame(width: 40, height: 4)
        .padding(.top, 8)

      VStack(spacing: 0) {
        ForEach(PhotographerReviewListFeature.SortOrder.allCases, id: \.self) {
          order in
          Button(action: { store.send(.selectOrder(order)) }) {
            HStack {
              Text(order.rawValue)
                .typo(.pParagraph)
                .foregroundStyle(
                  store.selectedOrder == order ? .pBlack : .pGrey4
                )
              Spacer()
              if store.selectedOrder == order {
                Image(systemName: "checkmark")
                  .foregroundStyle(.pBlack)
              }
            }
            .padding(.horizontal, 24)
            .frame(height: 56)
          }

          if order != PhotographerReviewListFeature.SortOrder.allCases.last {
            Divider()
              .background(.pGrey1)
              .padding(.horizontal, 24)
          }
        }
      }
      .padding(.top, 20)

      Spacer()
    }
    .background(.pWhite)
  }
}

#Preview {
  PhotographerReviewListView(
    store: Store(
      initialState: PhotographerReviewListFeature.State(
        photographerId: UUID(),
        photographerName: "유가영 작가",
        rating: 4.5,
        reviewCount: 32,
        reviews: PhotographerReview.mocks,
        topReviewImages: [
          UIImage(resource: .sampleVertical1).jpegData(
            compressionQuality: 0.8
          )!,
          UIImage(resource: .sampleVertical2).jpegData(
            compressionQuality: 0.8
          )!,
          UIImage(resource: .sampleVertical1).jpegData(
            compressionQuality: 0.8
          )!,
          UIImage(resource: .sampleVertical2).jpegData(
            compressionQuality: 0.8
          )!,
          UIImage(resource: .sampleVertical1).jpegData(
            compressionQuality: 0.8
          )!,
        ]
      )
    ) {
      PhotographerReviewListFeature()
    }
  )
}
