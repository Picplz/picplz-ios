//
//  PhotographerDetailHeader.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct PhotographerDetailHeader: View {
  let name: String
  let onBack: () -> Void
  let onMore: () -> Void
  
  var body: some View {
    HStack {
      Button(action: onBack) {
        Image(systemName: "chevron.left")
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(.pBlack)
      }
      
      Spacer()
      
      Text(name)
        .typo(.pParagraph)
        .foregroundStyle(.pBlack)
      
      Spacer()
      
      Button(action: onMore) {
        Image(systemName: "ellipsis")
          .rotationEffect(.degrees(90))
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(.pBlack)
      }
    }
    .padding(.horizontal, 16)
    .frame(height: 44)
    .background(.pWhite)
  }
}

#Preview {
  PhotographerDetailHeader(name: "유가영 작가", onBack: {}, onMore: {})
}
