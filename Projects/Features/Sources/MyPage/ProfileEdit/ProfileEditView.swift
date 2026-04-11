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
        VStack(spacing: 0) {
            SubNavigationBar(title: "프로필 수정") {
                store.send(.backButtonTapped)
            }

            if store.isPhotoPermissionDenied {
                photoPermissionDeniedView
            } else {
                editFormView
            }
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }

    // MARK: - 편집 폼

    private var editFormView: some View {
        VStack(spacing: 0) {
            // MARK: 프로필 이미지
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

            ScrollView {
                VStack(spacing: 24) {
                    nicknameSection
                        .padding(.top, 12)

                    if store.isPhotographer {
                        instagramSection
                        bioSection
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)

            // 완료 버튼
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
            .padding(.top, 12)
        }
    }

    // MARK: - 닉네임

    private var nicknameSection: some View {
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
                if let errorMessage = store.nicknameErrorMessage {
                    Text(errorMessage)
                        .typo(.pCaption)
                        .foregroundStyle(.pRed)
                } else {
                    Text("한글, 영문, 숫자만 가능합니다.")
                        .typo(.pCaption)
                        .foregroundStyle(.pGreen120)
                }
            }
        }
    }

    // MARK: - 인스타그램 아이디 (작가 전용)

    private var instagramSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("인스타그램 아이디")
                    .typo(.pSmallTitle)
                Spacer()
            }

            TextField("인스타그램 아이디를 적어주세요", text: $store.instagramUsername)
                .typo(.pParagraph)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(Color(.pGrey1))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.pGrey2), lineWidth: 1)
                )
        }
    }

    // MARK: - 자기소개 (작가 전용)

    private var bioSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("자기소개")
                    .typo(.pSmallTitle)
                Spacer()
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.pGrey1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.pGrey2), lineWidth: 1)
                    )

                if store.bio.isEmpty {
                    Text("자기소개를 입력해주세요")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $store.bio)
                    .typo(.pParagraph)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(store.bio.count)/\(ProfileEditFeature.maxBioLength)")
                            .typo(.pCaption)
                            .foregroundStyle(.pGrey4)
                            .padding(.trailing, 16)
                            .padding(.bottom, 12)
                    }
                }
            }
            .frame(height: 120)
        }
    }

    // MARK: - 사진 접근 권한 거부 뷰

    private var photoPermissionDeniedView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 12) {
                Text("사진 접근 권한을 허용해주세요")
                    .typo(.pTitle)
                    .foregroundStyle(.pBlack)

                Text("갤러리에서 사진을 가져오기 위해,\n아래 권한이 필요해요.")
                    .typo(.pBigParagraph)
                    .foregroundStyle(.pBlack)
                    .multilineTextAlignment(.center)

                Button {
                    store.send(.openPhotoSettingsTapped)
                } label: {
                    Text("사진 접근 허용하기")
                        .typo(.pButtonNormalLabel)
                        .foregroundStyle(.pWhite)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(.pBlack))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .padding(.top, 12)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("고객") {
    ProfileEditView(
        store: Store(
            initialState: ProfileEditFeature.State(nickname: "양원식")
        ) {
            ProfileEditFeature()
        }
    )
}

#Preview("작가") {
    ProfileEditView(
        store: Store(
            initialState: ProfileEditFeature.State(
                nickname: "유가영",
                isPhotographer: true,
                instagramUsername: "",
                bio: "안녕하세요, 임두현 사진작가입니다."
            )
        ) {
            ProfileEditFeature()
        }
    )
}

#Preview("사진 접근 권한 거부") {
    ProfileEditView(
        store: Store(
            initialState: ProfileEditFeature.State(
                nickname: "양원식",
                isPhotoPermissionDenied: true
            )
        ) {
            ProfileEditFeature()
        }
    )
}
