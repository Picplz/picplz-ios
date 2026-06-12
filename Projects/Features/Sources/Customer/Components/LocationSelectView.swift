//
//  LocationSelectView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import ComposableArchitecture

struct LocationSelectView: View {
  let store: StoreOf<LocationSelectFeature>
  
  var body: some View {
    VStack(spacing: 0) {
      // Title
      Text("지역별 작가 탐색")
        .typo(.pSmallTitle)
        .foregroundStyle(.pBlack)
        .padding(.top, 24) // 기본 그래버 아래 적당한 여백
        .padding(.bottom, 20)
      
      // City Tabs
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(store.cities, id: \.self) { city in
            Button(action: { store.send(.cityTapped(city)) }) {
              VStack(spacing: 8) {
                Text(city)
                  .typo(store.selectedCity == city ? .pBoldParagraph : .pParagraph)
                  .foregroundStyle(store.selectedCity == city ? .pBlack : .pGrey3)
                
                // Selection Indicator
                Rectangle()
                  .fill(store.selectedCity == city ? .pBlack : .clear)
                  .frame(height: 2)
              }
            }
          }
        }
        .padding(.horizontal, 16)
      }
      
      Divider()
        .background(.pGrey2)
      
      // District List
      ScrollView {
        VStack(spacing: 0) {
          ForEach(store.districts, id: \.self) { district in
            Button(action: { store.send(.districtTapped(district)) }) {
              HStack {
                Spacer()
                
                Text(district)
                  .typo(store.selectedDistrict == district ? .pBoldParagraph : .pParagraph)
                  .foregroundStyle(.pGrey5)
                
                Spacer()
              }
              .padding(.horizontal, 16)
              .padding(.vertical, 12)
              .background(store.selectedDistrict == district ? .pGrey1 : .pWhite)
            }
            
            Divider()
              .background(.pGrey2)
              .padding(.leading, 16)
          }
        }
      }
      .frame(maxHeight: 400)
      
      // Apply Button
      Button1(title: "적용하기") {
        store.send(.applyButtonTapped)
      }
      .padding(.horizontal, 16)
      .padding(.top, 20)
      .padding(.bottom, 40)
    }
    .background(.pWhite)
  }
}

#Preview {
  LocationSelectView(
    store: Store(initialState: LocationSelectFeature.State()) {
      LocationSelectFeature()
    }
  )
}
