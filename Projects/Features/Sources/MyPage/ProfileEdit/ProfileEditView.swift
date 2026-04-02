//
//  ProfileEditView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct ProfileEditView: View {
    @Bindable var store: StoreOf<ProfileEditFeature>

    var body: some View {
        VStack {
            // MARK: 상단 네비게이션 바
            HStack {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(.leftGoBlack)
                }
                Spacer()
            }
            .overlay {
                Text("프로필 수정")
                    .typo(.pParagraph)
            }
            
            // MARK: 프로필 이미지
            // TODO: 갤러리 연동
            Button {
                store.send(.profileImageTapped)
            } label: {
                Image(.profileImagePlaceholder)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 102, height: 102)
                    .clipShape(Circle())
                    .overlay(alignment: .bottomTrailing) {
                        Image(.cameraCircle)
                    }
            }
            .padding(.top, 12)
            
            // MARK: 닉네임 변경 바
            VStack(spacing: 12) {
                HStack {
                    Text("닉네임")
                        .typo(.pSmallTitle)
                    Spacer()
                }

                TextField("닉네임을 입력해주세요", text: $store.nickname)
                    .typo(.pParagraph)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(Color(.pGrey1))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.pGrey2), lineWidth: 1)
                    )
                HStack {
                    Spacer()
                    Text("한글, 영문, 숫자만 가능합니다.")
                        .typo(.pCaption)
                        .foregroundStyle(.pGreen120)
                }
            }
            .padding(.top, 12)
            
            Spacer()
            
            // TODO: 프로필 수정 API 연동
            Button {
                store.send(.completeButtonTapped)
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 50)
                    .foregroundStyle(.pBlack)
                    .overlay(
                        Text("완료")
                            .foregroundStyle(.pWhite)
                            .typo(.pButtonNormalLabel)
                    )
            }
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileEditView(
        store: Store(initialState: ProfileEditFeature.State()) {
            ProfileEditFeature()
        }
    )
}
