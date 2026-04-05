//
//  PhotographerReviewCard.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct PhotographerReviewCard: View {
  let authorName: String
  let rating: Double
  let date: String
  let content: String
  let option: String
  let location: String
  let imagesData: [Data]
  let onReport: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Header
      HStack(spacing: 8) {
        Circle()
          .fill(.pGrey2)
          .stroke(.pBlack)
          .frame(width: 36, height: 36)
        
        VStack(alignment: .leading, spacing: 2) {
          Text(authorName)
            .typo(.pBoldParagraph)
            .foregroundStyle(.pBlack)
          
          RatingView(rating: rating, starSize: 15, theme: .green)
        }
        
        Spacer()
        
        HStack(spacing: 4) {
          Button(action: onReport) {
            Text("신고")
              .typo(.pCaption)
              .foregroundStyle(.pGrey3)
              .padding(.horizontal, 6)
              .padding(.vertical, 2)
              .background(.pGrey1)
              .cornerRadius(5)
          }
          
          Text(date)
            .typo(.pCaption)
            .foregroundStyle(.pBlack)
        }
      }
      
      // Images
      if !imagesData.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 1) {
            ForEach(0..<imagesData.count, id: \.self) { index in
              if let uiImage = UIImage(data: imagesData[index]) {
                Image(uiImage: uiImage)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 113, height: 113)
                  .clipped()
              }
            }
          }
        }
        .cornerRadius(5)
      }
      
      // Info & Content
      VStack(alignment: .leading, spacing: 8) {
        VStack(alignment: .leading, spacing: 4) {
          infoRow(label: "옵션", value: option)
          infoRow(label: "촬영지", value: location)
        }
        
        Text(content)
          .typo(.pParagraph)
          .foregroundStyle(.pBlack)
      }
      
      // Like (Placeholder)
      HStack {
        Spacer()
        HStack(spacing: 4) {
          Image(systemName: "hand.thumbsup.fill")
            .font(.system(size: 14))
            .foregroundStyle(.pGrey2)
          Text("4")
            .typo(.pParagraph)
            .foregroundStyle(.pBlack)
        }
      }
    }
    .padding(.horizontal, 16)
  }
  
  private func infoRow(label: String, value: String) -> some View {
    HStack(spacing: 10) {
      Text(label)
        .typo(.pBoldParagraph)
        .foregroundStyle(.pGrey4)
      Text(value)
        .typo(.pParagraph)
        .foregroundStyle(.pGrey4)
    }
  }
}

#Preview {
  PhotographerReviewCard(
    authorName: "합정동 불주먹",
    rating: 4.5,
    date: "2024.12.03",
    content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
    option: "남친생기는 프사",
    location: "서울시 마포구 무대륙",
    imagesData: [],
    onReport: {}
  )
}
