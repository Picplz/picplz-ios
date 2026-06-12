//
//  PhotographerDetailView+RatingSection.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

extension PhotographerDetailView {
  struct RatingSection: View {
    let rating: Double
    let reviewCount: Int
    
    var body: some View {
      VStack(spacing: 4) {
        Text("촬영 만족도")
          .typo(.pSmallTitle)
          .foregroundStyle(.pBlack)
        
        HStack(spacing: 4) {
          RatingView(rating: rating)
          
          Text(String(format: "%.1f", rating))
            .typo(.pBoldParagraph)
            .foregroundStyle(.pGrey4)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 24)
    }
  }
}
