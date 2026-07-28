//
//  AccountManageView.swift
//  Features
//
//  Created by giwan jo on 7/13/26.
//

import SwiftUI
import ComposableArchitecture
import Domain

struct AccountManageView: View {
    let store: StoreOf<AccountManageFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "계정 관리") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 10) {
                    VStack(spacing: 0) {
                        infoRow(title: "이름", value: store.name)
                        infoRow(title: "휴대폰 번호", value: store.phoneNumber)
                        infoRow(title: "간편 로그인", value: store.signInProvider.accountDisplayName)
                        identityVerificationRow
                    }
                    .padding(.horizontal, 16)
                    .background(.pWhite)
                    
                    textItemView(
                        title: "로그아웃",
                        titleTypo: .pBoldParagraph,
                        titleColor: Color(.pGreen120)
                    ) {
                        store.send(.logoutTapped)
                    }
                    
                    textItemView(
                        title: "회원 탈퇴",
                        titleColor: Color(.pGrey3)
                    ) {
                        store.send(.withdrawTapped)
                    }
                }
                .background(.pGrey1)
            }
        }
        .background(.pWhite)
        .navigationBarHidden(true)
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)
            Spacer()
            Text(value)
                .typo(.pParagraph)
                .foregroundStyle(.pGrey3)
        }
        .frame(height: 52)
    }
    
    private var identityVerificationRow: some View {
        Button {
            store.send(.identityVerificationTapped)
        } label: {
            HStack {
                Text("본인인증")
                    .typo(.pParagraph)
                    .foregroundStyle(.pBlack)
                Spacer()
                HStack(spacing: 0) {
                    Text(store.isIdentityVerified ? "인증 완료" : "미인증")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey3)
                    Image(.arrowRightBig)
                        .foregroundStyle(.pGrey3)
                }
            }
            .frame(height: 52)
        }
        .buttonStyle(.plain)
    }
    
    private func textItemView(
        title: String,
        titleTypo: TypographyStyle = .pParagraph,
        titleColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .typo(titleTypo)
                    .foregroundStyle(titleColor)
                Spacer()
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
            .background(.white)
        }
        .buttonStyle(.plain)
    }
}

private extension SignInProvider {
    var accountDisplayName: String {
        switch self {
        case .kakao: return "카카오"
        case .apple: return "애플"
        }
    }
}

#Preview {
    AccountManageView(
        store: Store(initialState: AccountManageFeature.State()) {
            AccountManageFeature()
        }
    )
}
