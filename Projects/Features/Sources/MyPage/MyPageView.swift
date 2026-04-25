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
                                Text(store.isPhotographerMode ? "고객으로 전환" : "작가로 전환")
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

                    if store.isPhotographerMode {
                        PhotographerMyPageView(store: store)
                    } else {
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
            case .pastShootings:
                if let store = store.scope(
                    state: \.pastShootings,
                    action: \.pastShootings
                ) {
                    PastShootingsView(store: store)
                }
            case .settings:
                if let store = store.scope(
                    state: \.settings,
                    action: \.settings
                ) {
                    SettingsView(store: store)
                }
            case .followedArtists:
                if let store = store.scope(
                    state: \.followedArtists,
                    action: \.followedArtists
                ) {
                    FollowedArtistsView(store: store)
                }
            case .myReviews:
                if let store = store.scope(
                    state: \.myReviews,
                    action: \.myReviews
                ) {
                    MyReviewsView(store: store)
                }
            case .reviewDetail:
                if let store = store.scope(
                    state: \.reviewDetail,
                    action: \.reviewDetail
                ) {
                    ReviewDetailView(store: store)
                }
            case .packageEdit:
                if let store = store.scope(
                    state: \.packageEdit,
                    action: \.packageEdit
                ) {
                    PackageEditView(store: store)
                }
            case .packageAdd:
                if let store = store.scope(
                    state: \.packageAdd,
                    action: \.packageAdd
                ) {
                    PackageAddView(store: store)
                }
            case .portfolioAdd:
                if let store = store.scope(
                    state: \.portfolioAdd,
                    action: \.portfolioAdd
                ) {
                    PortfolioAddView(store: store)
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

#Preview("작가 모드") {
    MyPageView(
        store: Store(
            initialState: MyPageFeature.State(
                hasPhotographerInfo: true,
                isPhotographerMode: true,
                nickname: "가영포토",
                pastShootings: [
                    .init(
                        id: "1",
                        photographerName: "합정동작가",
                        photographerImageURL: nil,
                        title: "남친생기는 프사",
                        price: 12000,
                        status: .cancelled,
                        dateTime: "25.03.24 | 오후2:30",
                        location: "종로구 효자로 33",
                        paymentDate: "2025.03.01"
                    ),
                    .init(
                        id: "2",
                        photographerName: "유가영사진",
                        photographerImageURL: nil,
                        title: "인스타 피드꾸미기",
                        price: 12000,
                        status: .completed,
                        dateTime: "25.03.24 | 오후2:30",
                        location: "종로구 효자로 33",
                        paymentDate: "2025.03.01"
                    ),
                ],
                instagramUsername: nil,
                photographerBio: "안녕하세요, 유가영 작가입니다.",
                followerCount: 0,
                activeRegions: [
                    "서울 마포구", "서울 용산구", "서울 강남구", "서울 서초구",
                    "서울 성동구", "서울 송파구", "서울 종로구", "서울 중구",
                    "서울 영등포구", "서울 강서구", "서울 양천구", "서울 구로구",
                    "서울 금천구", "서울 관악구", "서울 동작구", "서울 은평구",
                    "경기 성남", "경기 수원"
                ],
                keywords: ["#개구장", "#디짐", "#맥주감성", "#감성스냅", "#우정샷", "#커플샷"],
                equipments: ["아이폰 16 PRO", "아이폰 X", "캐논 5D", "소니 A7", "라이카 M11"],
                packages: [
                    MyPageFeature.ShootingPackage(
                        id: "1",
                        title: "남친 생기는 프사♥",
                        price: 9900,
                        coverImageURL: nil,
                        shootingDuration: "15분 이내",
                        detail: "여자친구 /남자친구 생기는 카톡포사 찍어드립니당~ 요즘 인스타그램 감성으로 이쁘게!\n사용기기: 아이폰 X / 아이폰 16pro\n베스트컷 5개정도 길이 뽑아드려요!"
                    ),
                    MyPageFeature.ShootingPackage(
                        id: "2",
                        title: "여친 생기는 프사📸",
                        price: 15000,
                        coverImageURL: nil,
                        shootingDuration: "30분 이내",
                        detail: "감성 넘치는 프로필 사진 찍어드립니다!\n사용기기: 캐논 5D\n베스트컷 10장 보정 포함"
                    )
                ],
                portfolios: [
                    MyPageFeature.PortfolioImage(id: "1", imageURL: ""),
                    MyPageFeature.PortfolioImage(id: "2", imageURL: ""),
                    MyPageFeature.PortfolioImage(id: "3", imageURL: ""),
                    MyPageFeature.PortfolioImage(id: "4", imageURL: ""),
                    MyPageFeature.PortfolioImage(id: "5", imageURL: ""),
                    MyPageFeature.PortfolioImage(id: "6", imageURL: "")
                ],
                satisfactionRating: 4.5
            )
        ) {
            MyPageFeature()
        }
    )
}
