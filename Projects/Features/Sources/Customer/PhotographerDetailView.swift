//
//  PhotographerDetailView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import ComposableArchitecture

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
            name: store.photographer.name,
            followerCount: store.photographer.followerCount,
            instagramId: store.photographer.instagramId,
            description: store.photographer.description,
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
              value: store.photographer.locations,
              isExpandable: true,
              isExpanded: store.isLocationExpanded,
              onExpand: { store.send(.expandLocationTapped) }
            )
            PhotographerInfoRow(label: "키워드", value: store.photographer.keywords.joined(separator: ", "))
            PhotographerInfoRow(label: "장비", value: store.photographer.equipments)
          }
          .padding(.vertical, 20)
          
          // Section Divider (10px background)
          Rectangle()
            .fill(.pGrey1)
            .frame(height: 10)
          
          // Rating Section
          RatingSection(rating: store.photographer.rating, reviewCount: store.photographer.reviewCount)
          
          // Review Items (Mock)
          VStack(spacing: 20) {
            PhotographerReviewCard(
              authorName: "합정동 불주먹",
              rating: 4.5,
              date: "2024.12.03",
              content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
              option: "남친생기는 프사",
              location: "서울시 마포구 무대륙",
              imagesData: [],
              onReport: { store.send(.reportReviewTapped(UUID())) }
            )
            
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
          PortfolioGrid(imagesData: []) {
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
              PhotographerPackageCard(
                title: "남친 생기는 프사❤️",
                price: "9,900원",
                time: "15분 이내",
                info: "여자친구 /남자친구 생기는 카톡프사 찍어드립니당~ 요즘 인스타그램 감성으로 이쁘게! 베스트컷 5개정도 같이 뽑아드려용!",
                imageData: nil
              )
              .padding(.vertical, 12)
              
              Divider()
                .background(.pGrey2)
                .padding(.horizontal, 16)
              
              PhotographerPackageCard(
                title: "웨딩 아이폰 스냅💍",
                price: "12,900원",
                time: "30분~1시간",
                info: "비싼 아이폰 본식 스냅! 간단하고 빠르게 찍어드립니다~~ 하객이 찍은 것처럼 자연스럽게 찍어드립디당",
                imageData: nil
              )
              .padding(.vertical, 12)
              
              Divider()
                .background(.pGrey2)
                .padding(.horizontal, 16)
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
      photographer: PhotographerDetail(
        id: UUID(),
        name: "유가영 작가",
        profileImageData: nil,
        instagramId: "Gayoung",
        followerCount: 112,
        description: "차단된 작가입니다.",
        locations: "정보 없음",
        keywords: [],
        equipments: "정보 없음",
        rating: 0.0,
        reviewCount: 0,
        isBookable: false,
        isBlocked: true
      )
    )) {
      PhotographerDetailFeature()
    }
  )
}
