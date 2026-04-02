//
//  MyPageView.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    @Bindable var store: StoreOf<MyPageFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                // 네비게이션 바
                HStack {
                    Text("마이 페이지")
                        .typo(.pBoldParagraph)
                    Spacer()
                    Button {
                        store.send(.settingsTapped)
                    } label: {
                        Image(.settings)
                    }
                }
                .padding(.horizontal, 16)

                ScrollView {
                    // 작가 변경 바
                    Group {
                        if store.hasPhotographerInfo {
                            HStack {
                                Text("작가로 전환")
                                    .typo(.pBoldParagraph)
                                    .foregroundStyle(.white)
                                Spacer()
                                Toggle("", isOn: $store.isPhotographerMode.sending(\.togglePhotographerMode))
                                    .labelsHidden()
                                    .toggleStyle(PicToggleStyle())
                            }
                            .padding(.horizontal, 16)
                        } else {
                            HStack {
                                Text("작가로도 활동하기")
                                    .typo(.pBoldParagraph)
                                    .foregroundStyle(.white)
                                Spacer()
                                Button {
                                    store.send(.navigateToPhotographerRegister)
                                } label: {
                                    Image(.rightGoWhite)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(height: 50)
                    .background(Color(.pGreen120))

                    // MARK: 프로필 섹션
                    // TODO: 프로필 이미지 실제 URL 로딩 적용
                    HStack(spacing: 8) {
                        Image(.profileImagePlaceholder)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())

                        Text(store.nickname)
                            .typo(.pBigParagraph)

                        Spacer()

                        Button {
                            store.send(.profileEditTapped)
                        } label: {
                            Text("프로필 수정")
                                .typo(.pBoldParagraph)
                                .foregroundStyle(.pGrey4)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(.pGrey3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)

                    Rectangle()
                        .fill(Color(.pGrey2))
                        .frame(height: 1)
                        .padding(.horizontal, 16)

                    // MARK: 진행중인 촬영 섹션
                    HStack {
                        if store.activeShootings.isEmpty {
                            Text("진행중인 촬영")
                                .typo(.pSmallTitle)
                                .foregroundStyle(.pBlack)
                        } else {
                            Text("진행중인 촬영 (\(store.activeShootings.count))")
                                .typo(.pSmallTitle)
                                .foregroundStyle(.pBlack)
                        }
                        Spacer()
                        Button {
                            store.send(.pastShootingsTapped)
                        } label: {
                            Text("지난 촬영 내역")
                                .typo(.pCaption)
                                .foregroundStyle(.pGrey3)
                            Image(systemName: "chevron.right")
                                .typo(.pCaption)
                                .foregroundStyle(.pGrey3)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)

                    if store.activeShootings.isEmpty {
                        emptyShootingView
                    } else {
                        activeShootingsView
                    }

                    Rectangle()
                        .fill(Color(.pGrey1))
                        .frame(height: 10)

                    // MARK: 메뉴 리스트
                    // TODO: 각 메뉴 화면 네비게이션 연결
                    VStack(spacing: 0) {
                        menuRow("팔로우 작가") {
                            store.send(.followedArtistsTapped)
                        }
                        menuRow("내 리뷰") {
                            store.send(.myReviewsTapped)
                        }
                        menuRow("이용 약관") {
                            store.send(.termsOfServiceTapped)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        } destination: { store in
            switch store.state {
            case .profileEdit:
                if let store = store.scope(
                    state: \.profileEdit,
                    action: \.profileEdit
                ) {
                    ProfileEditView(store: store)
                }
            }
        }
    }

    // MARK: - 진행중인 촬영이 없을때

    private var emptyShootingView: some View {
        Button {
            store.send(.navigateToSearch)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("진행중인 촬영이 없어요")
                        .typo(.pSmallTitle)
                        .foregroundStyle(.pBlack)

                    Text("촬영지를 검색하고 작가들을 둘러보세요")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                }
                Spacer()
                Image(.rightGoBlack)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.pGrey3), lineWidth: 1)
            )
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }

    // MARK: - 진행중인 촬영이 있을때

    private var activeShootingsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(store.activeShootings) { shooting in
                    ShootingCardView(shooting: shooting) {
                        store.send(.shootingCardTapped(shooting.id))
                    }
                    .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    // MARK: - 메뉴 행

    private func menuRow(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .typo(.pBigParagraph)
                    .foregroundStyle(.pBlack)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview("촬영 없음") {
    MyPageView(
        store: Store(
            initialState: MyPageFeature.State(
                hasPhotographerInfo: true,
                nickname: "양원식"
            )
        ) {
            MyPageFeature()
        }
    )
}

#Preview("촬영 있음") {
    MyPageView(
        store: Store(
            initialState: MyPageFeature.State(
                hasPhotographerInfo: true,
                nickname: "양원식",
                activeShootings: [
                    .init(
                        id: "1",
                        photographerName: "합정동 불주먹",
                        photographerImageURL: nil,
                        status: "예약 확정",
                        title: "남친생기는 프사",
                        dateTime: "25.07.23",
                        location: "종로구 효자로 33"
                    ),
                    .init(
                        id: "2",
                        photographerName: "성수동 감성작가",
                        photographerImageURL: nil,
                        status: "예약 확정",
                        title: "커플 스냅",
                        dateTime: "25.08.05",
                        location: "성동구 서울숲길 17"
                    ),
                ]
            )
        ) {
            MyPageFeature()
        }
    )
}
