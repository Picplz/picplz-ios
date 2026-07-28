//
//  TermsView.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import SwiftUI
import ComposableArchitecture

struct TermsView: View {
    let store: StoreOf<TermsFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "약관 및 정책") {
                store.send(.backButtonTapped)
            }
            
            ForEach(TermsFeature.TermsItem.allCases, id: \.self) { item in
                chevronItemView(title: item.title) {
                    store.send(.termsRowTapped(item))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.pWhite)
        .navigationBarHidden(true)
    }
    
    private func sectionItemView(left: some View, right: some View) -> some View {
        HStack {
            left
            Spacer()
            right
        }
        .frame(height: 52)
    }
    
    private func chevronItemView(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            sectionItemView(
                left: Text(title)
                    .typo(.pParagraph)
                    .foregroundStyle(.pBlack),
                right: Image(.arrowRightBig)
                    .foregroundStyle(.pGrey3)
                    .frame(width: 20, height: 20)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TermsView(
        store: Store(initialState: TermsFeature.State()) {
            TermsFeature()
        }
    )
}
