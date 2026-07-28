//
//  InquiryView.swift
//  Features
//
//  Created by giwan jo on 7/21/26.
//

import SwiftUI
import ComposableArchitecture

struct InquiryView: View {
    let store: StoreOf<InquiryFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "문의하기") {
                store.send(.backButtonTapped)
            }
            
            HStack {
                Text("이메일 문의")
                    .typo(.pBigParagraph2)
                    .foregroundStyle(.pBlack)
                Spacer()
            }
            .frame(height: 42)
            
            Button {
                store.send(.emailInquiryTapped)
            } label: {
                HStack {
                    Text("이메일로 문의사항을 보내주세요.")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                    Spacer()
                    Image(.arrowRightBig)
                        .foregroundStyle(.pGrey3)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 40)
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.pWhite)
        .navigationBarHidden(true)
    }
}

#Preview {
    InquiryView(
        store: Store(initialState: InquiryFeature.State()) {
            InquiryFeature()
        }
    )
}
