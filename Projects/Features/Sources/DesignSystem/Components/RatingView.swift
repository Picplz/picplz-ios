//
//  RatingView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct RatingView: View {
  enum StarTheme {
    case black
    case green
    
    var fullImageName: ImageResource {
      self == .black ? .starFullBlack : .starFullGreen
    }
    
    var emptyImageName: ImageResource {
      self == .black ? .starEmptyBlack : .starEmptyGreen
    }
  }

  let rating: Double
  let maxRating: Int = 5
  var starSize: CGFloat = 20
  var spacing: CGFloat = 1
  var theme: StarTheme = .black // Default theme
  
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
    if rating >= Double(index + 1) {
      return Image(theme.fullImageName)
    } else {
      return Image(theme.emptyImageName)
    }
  }
}

#Preview {
  VStack {
    RatingView(rating: 5.0)
    RatingView(rating: 3.0, starSize: 15, theme: .green)
    RatingView(rating: 0.0)
  }
}
