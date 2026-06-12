//
//  PhotographerDetailHeader.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import Domain

struct PhotographerDetailHeader: View {
  let name: String
  let onBack: () -> Void
  let onMore: () -> Void
  
  var body: some View {
    TempPicNavigationBar(title: name, onBack: onBack) {
      Button(action: onMore) {
        Image(systemName: "ellipsis")
          .rotationEffect(.degrees(90))
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(.pBlack)
      }
    }
  }
}

#Preview {
  PhotographerDetailHeader(name: PhotographerDetail.mock.name, onBack: {}, onMore: {})
}
