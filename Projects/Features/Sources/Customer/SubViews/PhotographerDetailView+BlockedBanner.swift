//
//  PhotographerDetailView+BlockedBanner.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

extension PhotographerDetailView {
  struct BlockedBanner: View {
    let onUnblock: () -> Void
    
    var body: some View {
      HStack {
        Text("차단된 계정입니다.")
          .typo(.pBoldParagraph)
          .foregroundStyle(.pWhite)
        
        Spacer()
        
        Button(action: onUnblock) {
          Text("차단 해제")
            .typo(.pParagraph)
            .foregroundStyle(.pWhite)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(.pRed)
    }
  }
}
