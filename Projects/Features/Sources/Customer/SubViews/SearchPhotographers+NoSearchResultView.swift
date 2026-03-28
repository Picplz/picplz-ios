//
//  SearchPhotographersNoSearchResultView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

extension SearchPhotographersView {
  struct NoSearchResultView: View {
    var body: some View {
      VStack(spacing: 12) {
        Text("검색 결과가 없습니다")
          .typo(.pSmallTitle)
          .foregroundStyle(.pGrey5)
        
        Image(.notfound)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 64, height: 64)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
