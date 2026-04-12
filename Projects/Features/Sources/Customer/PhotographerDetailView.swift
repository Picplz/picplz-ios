//
//  PhotographerDetailView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import ComposableArchitecture
import Domain

public struct PhotographerDetailView: View {
  let store: StoreOf<PhotographerDetailFeature>
  
  public init(store: StoreOf<PhotographerDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      // Header
      PhotographerDetailHeader(
        name: store.photographer.name,
        onBack: { store.send(.backButtonTapped) },
        onMore: { store.send(.moreButtonTapped) }
      )
      
      // Blocked Banner
      if store.photographer.isBlocked {
        BlockedBanner {
          store.send(.unblockButtonTapped)
        }
      }
      
      // Main Content
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          // Profile Section
          PhotographerProfileSection(
            photographer: store.photographer,
            isExpanded: store.isDescriptionExpanded,
            onFollow: { store.send(.followButtonTapped) },
            onExpand: { store.send(.expandDescriptionTapped) }
          )
          .padding(.vertical, 20)
          
          Divider()
            .background(.pGrey2)
            .padding(.horizontal, 16)
          
          // Info Rows
          VStack(spacing: 8) {
            PhotographerInfoRow(
              label: "촬영지",
              value: store.photographer.locationsText,
              isExpandable: true,
              isExpanded: store.isLocationExpanded,
              onExpand: { store.send(.expandLocationTapped) }
            )
            PhotographerInfoRow(label: "키워드", value: store.photographer.keywordsText)
            PhotographerInfoRow(label: "장비", value: store.photographer.equipmentsText)
          }
          .padding(.vertical, 20)
          
          // Section Divider (10px background)
          Rectangle()
            .fill(.pGrey1)
            .frame(height: 10)
          
          // Rating Section
          RatingSection(rating: store.photographer.rating, reviewCount: store.photographer.reviewCount)
          
          VStack(spacing: 20) {
            ForEach(store.photographer.reviews) { review in
              PhotographerReviewCard(
                review: review,
                onReport: { store.send(.reportReviewTapped(review.id)) }
              )
            }
            
            Button(action: {}) {
              HStack(spacing: 4) {
                Spacer()
                Text("전체 리뷰 보러가기 (\(store.photographer.reviewCount))")
                  .typo(.pCaption)
                  .foregroundStyle(.pGrey4)
                Image(systemName: "chevron.right")
                  .font(.system(size: 10))
                  .foregroundStyle(.pGrey4)
              }
            }
            .padding(.horizontal, 16)
          }
          .padding(.bottom, 20)
          
          Divider()
            .background(.pGrey2)
            .padding(.horizontal, 16)
          
          // Portfolio Grid
          PortfolioGrid(imagesData: store.photographer.portfolioImagesData) {
            // More action
          }
          
          // Package Section
          VStack(alignment: .leading, spacing: 0) {
            Text("촬영 패키지")
              .typo(.pSmallTitle)
              .foregroundStyle(.pBlack)
              .padding(.horizontal, 16)
              .padding(.top, 40)
            
            VStack(spacing: 0) {
              ForEach(Array(store.photographer.packages.enumerated()), id: \.element.id) { index, package in
                PhotographerPackageCard(package: package)
                  .padding(.vertical, 12)

                if index < store.photographer.packages.count - 1 {
                  Divider()
                    .background(.pGrey2)
                    .padding(.horizontal, 16)
                }
              }
            }
          }
          
          Spacer().frame(height: 100)
        }
      }
      
      // Fixed Footer Button
      VStack(spacing: 0) {
        if store.photographer.isBookable {
          Button1(title: "예약하기") {
            store.send(.reserveButtonTapped)
          }
        } else {
          Button(action: {}) {
            RoundedRectangle(cornerRadius: 5)
              .fill(.pGrey3)
              .frame(height: 50)
              .overlay(
                Text("현재 예약을 받지 않아요")
                  .typo(.pButtonNormalLabel)
                  .foregroundStyle(.pWhite)
              )
          }
          .disabled(true)
        }
      }
      .padding(.horizontal, 16)
      .padding(.top, 20)
      .padding(.bottom, 40)
      .background(.pWhite)
      .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
    }
    .background(.pWhite)
    .navigationBarHidden(true)
  }
}

#Preview {
  PhotographerDetailView(
    store: Store(initialState: PhotographerDetailFeature.State()) {
      PhotographerDetailFeature()
    }
  )
}

#Preview("Blocked State") {
  PhotographerDetailView(
    store: Store(initialState: PhotographerDetailFeature.State(
      photographer: .blockedMock
    )) {
      PhotographerDetailFeature()
    }
  )
}
