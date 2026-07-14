//
//  WithdrawView.swift
//  Features
//
//  Created by giwan jo on 7/14/26.
//

import SwiftUI
import ComposableArchitecture

struct WithdrawView: View {
    let store: StoreOf<WithdrawFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "회원 탈퇴") {
                store.send(.backButtonTapped)
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("탈퇴 시 모든 정보가 사라지며, 되돌릴 수 없습니다.")
                    .typo(.pBoldParagraph)
                    .foregroundStyle(.pBlack)

                noticeHeader
                    .padding(.top, 24)

                noticeList
                    .padding(.top, 16)
            }
            .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                agreementCheckbox
                
                withdrawButton
                    .padding(.top, 20)
            }
            .padding(.top, 70)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.pWhite)
        .navigationBarHidden(true)
    }

    private var noticeHeader: some View {
        HStack(spacing: 6) {
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.pRed)
                .overlay {
                    Image(.i)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 3, height: 11)
                        .offset(x: 0.5)
                }
            Text("탈퇴 시 유의사항 안내")
                .typo(.pBoldParagraph)
                .foregroundStyle(.pGrey5)
        }
    }

    private var noticeList: some View {
        VStack(alignment: .leading, spacing: 3) {
            noticeRow(
                index: "1.",
                text: "회원 탈퇴 시, 즉시 탈퇴 처리되며 서비스 이용이 불가합니다."
            )
            noticeRow(
                index: "2.",
                text: "회원 정보는 탈퇴 후 즉시 삭제됩니다. 다만 부정 이용·거래 방지 및 전자상거래법 등 관련 법령에 따라 보관이 필요한 경우 해당 기간동안 회원 정보가 보관 됩니다."
            )
        }
    }

    private func noticeRow(index: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text(index)
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)
                .frame(width: 14)
            Text(text)
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var agreementCheckbox: some View {
        Button {
            store.send(.agreementToggled)
        } label: {
            HStack(spacing: 6) {
                Image(store.isAgreed ? .checkActive : .checkInactive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("위 유의사항을 모두 확인하였습니다.")
                    .typo(.pParagraph)
                    .foregroundStyle(store.isAgreed ? .pBlack : .pGrey4)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }

    private var withdrawButton: some View {
        Button {
            store.send(.withdrawButtonTapped)
        } label: {
            Text("회원 탈퇴")
                .typo(.pButtonNormalLabel)
                .foregroundStyle(.pWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(store.isAgreed ? .pBlack : .pGrey4)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.plain)
        .disabled(!store.isAgreed)
    }
}

#Preview {
    WithdrawView(
        store: Store(initialState: WithdrawFeature.State()) {
            WithdrawFeature()
        }
    )
}
