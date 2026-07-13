//
//  NotificationSettingView.swift
//  Features
//
//  Created by giwanjo on 7/9/26.
//

import SwiftUI
import ComposableArchitecture

struct NotificationSettingView: View {
    @Bindable var store: StoreOf<NotificationSettingFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "알림 설정") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 10) {
                    serviceSection
                    marketingSection
                }
                .background(.pGrey1)
            }
        }
        .background(.pWhite)
        .navigationBarHidden(true)
    }

    private var serviceSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(
                title: "서비스 알림",
                description: "설정한 정보의 알림과 활동 소식 알림 등의 정보를 푸시로 알려 드립니다."
            )

            divider

            toggleRow(
                title: "촬영 내역 알림",
                subtitle: "촬영에 필요한 정보를 알려드려요.",
                isOn: $store.shootingNotificationEnabled
            )

            toggleRow(
                title: "채팅 알림",
                subtitle: "새로운 채팅이 도착하면 알려드려요.",
                isOn: $store.chatNotificationEnabled
            )
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 16)
        .background(.white)
    }

    private var marketingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("마케팅 정보 알림")
                        .typo(.pParagraph)
                        .foregroundStyle(.pBlack)
                    Spacer()
                    Button {
                        store.send(.marketingTermsTapped)
                    } label: {
                        Text("약관 보기")
                            .typo(.pCaption)
                            .foregroundStyle(Color(.pGreen120))
                    }
                    .buttonStyle(.plain)
                }
                
                Text("이벤트, 할인 등 다양한 혜택을 알려 드립니다.")
                    .typo(.pCaption)
                    .foregroundStyle(.pGrey4)
            }
            .padding(.vertical, 16)

            divider

            toggleRow(title: "전체 알림 받기", isOn: $store.marketingAllEnabled)
                .frame(height: 55)

            toggleRow(
                title: "푸시 알림",
                isOn: $store.marketingPushEnabled,
                enabled: store.marketingAllEnabled
            )
            .frame(height: 47)

            toggleRow(
                title: "SMS",
                isOn: $store.marketingSMSEnabled,
                enabled: store.marketingAllEnabled
            )
            .frame(height: 47)
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
        .background(.white)
    }

    private func sectionHeader(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .typo(.pParagraph)
                .foregroundStyle(.pBlack)
            Text(description)
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
    }

    private var divider: some View {
        Rectangle()
            .fill(.pGrey2)
            .frame(height: 1)
    }

    private func toggleRow(
        title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>,
        enabled: Bool = true
    ) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .typo(.pParagraph)
                    .foregroundStyle(.pBlack)
                if let subtitle {
                    Text(subtitle)
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey4)
                }
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .disabled(!enabled)
                .toggleStyle(PicToggleStyle())
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    NotificationSettingView(
        store: Store(initialState: NotificationSettingFeature.State()) {
            NotificationSettingFeature()
        }
    )
}
