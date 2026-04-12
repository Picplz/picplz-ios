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
            .foregroundStyle(.pBlack)
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
        
        Text(review.content)
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

  private var authorName: String {
    review.authorName
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
    onReport: {}
  )
}
