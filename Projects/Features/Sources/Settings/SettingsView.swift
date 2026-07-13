//
//  SettingsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "설정") {
                store.send(.backButtonTapped)
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    sectionView(header: "알림 설정") {
                        chevronItemView(title: "알림 설정") {
                            store.send(.notificationSettingTapped)
                        }
                    }
                    
                    sectionView(header: "사용자 설정") {
                        chevronItemView(title: "계정 관리") {
                            store.send(.accountManagementTapped)
                        }
                    }
                    
                    sectionView(header: "회원 구분") {
                        chevronItemView(title: "작가 회원 신청하기") {
                            store.send(.authorApplicationTapped)
                        }
                    }
                    
                    sectionView(header: "고객 지원") {
                        chevronItemView(title: "문의하기") {
                            store.send(.inquiryTapped)
                        }
                        chevronItemView(title: "공지사항") {
                            store.send(.noticeTapped)
                        }
                        chevronItemView(title: "약관 및 정책") {
                            store.send(.termsAndPoliciesTapped)
                        }
                    }
                    
                    sectionItemView(
                        left: Text("앱 버전 \(store.appVersion)")
                            .typo(.pParagraph)
                            .foregroundStyle(.pBlack),
                        right: Text(store.isLatestVersion ? "최신 버전이에요." : "새로운 업데이트가 있어요.")
                            .typo(.pParagraph)
                            .foregroundStyle(.pGrey3)
                    )
                    .padding(.horizontal, 16)
                    .background(.white)
                }
                .background(.pGrey1)
            }
        }
        .background(.pWhite)
        .navigationBarHidden(true)
    }
    
    private func sectionView(header: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(spacing: 0) {
            sectionHeaderView(title: header)
            content()
        }
        .padding(.horizontal, 16)
        .background(.white)
    }
    
    private func sectionHeaderView(title: String) -> some View {
        HStack {
            Text(title)
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)
            Spacer()
        }
        .frame(height: 37)
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
            )
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    SettingsView(
        store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    )
}
