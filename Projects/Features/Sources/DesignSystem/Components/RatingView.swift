//
//  RatingView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct RatingView: View {
  let rating: Double
  let maxRating: Int = 5
  var starSize: CGFloat = 20
  var spacing: CGFloat = 1
  
  var body: some View {
    HStack(spacing: spacing) {
      ForEach(0..<maxRating, id: \.self) { index in
        starImage(for: index)
          .resizable()
          .frame(width: starSize, height: starSize)
      }
    }
  }
  
  private func starImage(for index: Int) -> Image {
    let threshold = Double(index) + 0.5
    if rating >= Double(index + 1) {
      return Image(systemName: "star.fill")
    } else if rating >= threshold {
      return Image(systemName: "star.leadinghalf.filled")
    } else {
      return Image(systemName: "star")
    }
  }
}

#Preview {
  VStack {
    RatingView(rating: 4.5)
    RatingView(rating: 3.0, starSize: 15)
    RatingView(rating: 0.0)
  }
}
