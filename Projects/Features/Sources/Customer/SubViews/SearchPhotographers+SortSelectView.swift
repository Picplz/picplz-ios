//
//  SearchPhotographersSortSelectView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import ComposableArchitecture

extension SearchPhotographersView {
  struct SortSelectView: View {
    let store: StoreOf<SortSelectFeature>
    
    var body: some View {
      VStack(spacing: 0) {
        Text("정렬 순서")
          .typo(.pSmallTitle)
          .foregroundStyle(.pBlack)
          .padding(.top, 24)
          .padding(.bottom, 16)
        
        ForEach(SearchPhotographersFeature.SortOrder.allCases, id: \.self) { order in
          Button(action: { store.send(.selectOrder(order)) }) {
            VStack(spacing: 0) {
              Text(order.rawValue)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
                .frame(height: 57)
                .frame(maxWidth: .infinity)
              
              if order != SearchPhotographersFeature.SortOrder.allCases.last {
                Divider()
                  .background(.pGrey2)
                  .padding(.horizontal, 16)
              }
            }
          }
        }
        
        Spacer()
      }
      .background(.pWhite)
    }
  }
}
