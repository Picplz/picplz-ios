//
//  SearchPhotographersView.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import ComposableArchitecture

public struct SearchPhotographersView: View {
  @Bindable var store: StoreOf<SearchPhotographersFeature>
  
  public init(store: StoreOf<SearchPhotographersFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      // Custom Header
      HStack(spacing: 12) {
        Button(action: { store.send(.backButtonTapped) }) {
          Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.pBlack)
        }
        
        // 새로운 파사드 인터페이스 사용
        TextField(
          "촬영을 하고 싶은 작가를 검색해보세요",
          text: $store.searchQuery,
          prompt: Text("촬영을 하고 싶은 작가를 검색해보세요").foregroundStyle(.pGrey3)
        )
        .pSearchTextFieldWithClear(text: $store.searchQuery) {
          store.send(.searchButtonTapped)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 11)
      .background(.pWhite)
      
      // Content Area
      ZStack {
        VStack(spacing: 0) {
          if store.searchResultState == .results || store.searchResultState == .searching {
            // Sort Dropdown
            HStack {
              Button(action: { store.send(.sortDropdownTapped) }) {
                HStack(spacing: 4) {
                  Text(store.sortOrder.rawValue)
                    .typo(.pCaption)
                    .foregroundStyle(.pGrey5)
                  
                  Image(systemName: "chevron.down")
                    .font(.system(size: 8))
                    .foregroundStyle(.pGrey5)
                }
              }
              Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            // Results List
            ScrollView {
              LazyVStack(spacing: 0) {
                ForEach(store.photographers) { photographer in
                  PhotographerListItem(photographer: photographer) {
                    store.send(.photographerTapped(photographer.id))
                  }
                }
              }
            }
          } else if store.searchResultState == .noResults {
            NoSearchResultView()
          } else {
            // Idle State
            Spacer()
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(.pWhite)
    .navigationBarHidden(true)
    .sheet(
      item: $store.scope(state: \.sortModal, action: \.sortModal)
    ) { sortStore in
      SortSelectView(store: sortStore)
        .presentationDetents([.height(240)])
        .presentationDragIndicator(.visible)
    }
  }
}

#Preview {
  SearchPhotographersView(
    store: Store(initialState: SearchPhotographersFeature.State()) {
      SearchPhotographersFeature()
    }
  )
}
