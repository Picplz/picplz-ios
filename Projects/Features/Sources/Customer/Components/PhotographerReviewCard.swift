//
//  PhotographerReviewCard.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import Domain

struct PhotographerReviewCard: View {
  let review: PhotographerReview
  let onReport: () -> Void
  let onLike: () -> Void
  
  @State private var isExpanded: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Header
      HStack(spacing: 8) {
        Circle()
          .fill(.pGrey2)
          .stroke(.pBlack, lineWidth: 1)
          .frame(width: 36, height: 36)
        
        VStack(alignment: .leading, spacing: 2) {
          Text(review.authorName)
            .typo(.pBoldParagraph)
            .foregroundStyle(.pBlack)
          
          RatingView(rating: review.rating, starSize: 15, theme: .green)
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
          
          Text(review.dateText)
            .typo(.pCaption)
            .foregroundStyle(.pGrey4)
        }
      }
      
      // Images
      if !review.imagesData.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 1) {
            ForEach(0..<review.imagesData.count, id: \.self) { index in
              if let uiImage = UIImage(data: review.imagesData[index]) {
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
          infoRow(label: "옵션", value: review.option)
          infoRow(label: "촬영지", value: review.location)
        }
        
        ZStack(alignment: .bottomTrailing) {
          Text(review.content)
            .typo(.pParagraph)
            .foregroundStyle(.pBlack)
            .lineLimit(isExpanded ? nil : 2)
          
          if !isExpanded && review.content.count > 40 { // Simple heuristic for truncation
            Button(action: { isExpanded = true }) {
              Text("...더보기")
                .typo(.pParagraph)
                .foregroundStyle(.pBlack)
                .background(.pWhite)
            }
          }
        }
      }
      
      // Like
      HStack {
        Spacer()
        Button(action: onLike) {
          HStack(spacing: 4) {
            Image(.thumbsUp)
            Text("\(review.likeCount)")
              .typo(.pParagraph)
              .foregroundStyle(.pBlack)
          }
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
    review: .mock,
    onReport: {},
    onLike: {}
  )
}
