//
//  AccountManageView.swift
//  Features
//
//  Created by giwan jo on 7/13/26.
//

import SwiftUI
import ComposableArchitecture

struct AccountManageView: View {
    let store: StoreOf<AccountManageFeature>

    var body: some View {
        VStack {
            SubNavigationBar(title: "계정 관리") {
                store.send(.backButtonTapped)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.pWhite)
        .navigationBarHidden(true)
    }
}

#Preview {
    AccountManageView(
        store: Store(initialState: AccountManageFeature.State()) {
            AccountManageFeature()
        }
    )
}
