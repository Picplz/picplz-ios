//
//  OnboardingView.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI

struct OnboardingView: View {
  @State var activeIndex: Int? = 0
  
  let onboardingData = OnboardingData.defaultData
  let indicatorTopSpacing: CGFloat = 22
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          ForEach(0..<onboardingData.count, id: \.self) { index in
            VStack(spacing: indicatorTopSpacing) {
              OnboardingPage(data: .defaultData[index])
              PageIndicator(currentPage: index, totalPages: onboardingData.count)
                .styled(.onboarding)
              Spacer()
            }
            .frame(width: geometry.size.width)
          }
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.paging)
      .scrollPosition(id: $activeIndex)
    }
    .ignoresSafeArea(edges: .top)
  }
}

#Preview {
  OnboardingView()
}
