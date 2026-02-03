//
//  OnboardingPage.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI

struct OnboardingPage: View {
  let data: OnboardingData
  
  var body: some View {
    VStack(spacing: 34) {
      Image(data.guideImage)
      Text(data.guideMessage)
        .typo(.pBigTitle)
        .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  VStack {
    OnboardingPage(data: .defaultData.first!)
    
    Spacer()
  }
  .ignoresSafeArea(edges: .top)
}
