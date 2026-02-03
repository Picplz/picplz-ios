//
//  OnboardingView.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI
import Domain

struct OnboardingView: View {
  @State var activeIndex: Int? = 0
  
  let loginButtonTapped: (SignInProvider) -> Void
  
  let onboardingData = OnboardingData.defaultData
  let indicatorTopSpacing: CGFloat = 22
  let indicatorBottomSpacing: CGFloat = 30
  let loginButtonSpacing: CGFloat = 6
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          ForEach(0..<onboardingData.count, id: \.self) { index in
            VStack(spacing: 0) {
              OnboardingPage(data: .defaultData[index])
              
              Spacer()
                .frame(height: indicatorTopSpacing)
              
              PageIndicator(currentPage: index, totalPages: onboardingData.count)
                .styled(.onboarding)
              
              Spacer()
                .frame(height: indicatorBottomSpacing)
              
              if index == onboardingData.count - 1 {
                VStack(spacing: 6) {
                  ForEach(SignInProvider.allCases, id: \.self) { provider in
                    LoginButton {
                      loginButtonTapped(provider)
                    }
                    .provider(provider)
                  }
                }
                .padding(.horizontal, 15)
              }
              
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
  OnboardingView { provider in }
}
