//
//  PageIndicator.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI

struct PageIndicator: View {
  /// 현재 페이지 인덱스 (0부터 시작)
  let currentPage: Int
  /// 전체 페이지 수 (마지막 인덱스 + 1)
  let totalPages: Int
  /// 스타일
  var style: Style = .defaultStyle
  
  var body: some View {
    HStack(spacing: style.dotSpacing) {
      ForEach(0..<currentPage, id:\.self) { _ in
        deactivatedDot
      }
      
      activatedDot
      
      ForEach(currentPage..<totalPages-1, id:\.self) { _ in
        deactivatedDot
      }
    }
  }
  
  var activatedDot: some View {
    Circle()
      .foregroundStyle(style.activatedColor)
      .frame(width: style.dotSize, height: style.dotSize)
  }
  
  @ViewBuilder
  var deactivatedDot: some View {
    let base = Circle()
      .foregroundStyle(style.deactivatedColor)
      .frame(width: style.dotSize, height: style.dotSize)
    
    if style.deativatedBorderWidth > 0 {
      base
        .overlay(
          Circle()
            .stroke(style.deativatedBorderColor, lineWidth: style.deativatedBorderWidth)
        )
    } else {
      base
    }
  }
  
  func styled(_ style: Style) -> PageIndicator {
    var copy = self
    copy.style = style
    return copy
  }
}

extension PageIndicator {
  enum Style {
    case defaultStyle
    case onboarding
    
    var dotSize: CGFloat {
      switch self {
      case .defaultStyle:
        6
      case .onboarding:
        12
      }
    }
    
    var dotSpacing: CGFloat {
      switch self {
      case .defaultStyle:
        6
      case .onboarding:
        9
      }
    }
    
    var activatedColor: Color {
      switch self {
      case .defaultStyle:
        .pBlack
      case .onboarding:
        .pBlack
      }
    }
    
    var deactivatedColor: Color {
      switch self {
      case .defaultStyle:
        .pBlack.opacity(0.2)
      case .onboarding:
        .pWhite
      }
    }
    
    var deativatedBorderColor: Color {
      switch self {
      case .defaultStyle:
        .clear
      case .onboarding:
        .pBlack
      }
    }
    
    var deativatedBorderWidth: CGFloat {
      switch self {
      case .defaultStyle:
        0
      case .onboarding:
        1
      }
    }
  }
}

#Preview {
  PageIndicator(currentPage: 2, totalPages: 3)
  
  PageIndicator(currentPage: 1, totalPages: 4)
    .styled(.onboarding)
}
