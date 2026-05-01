//
//  PhotographerMyPageView.swift
//  Features
//
//  Created by wonsik on 4/11/26.
//

import SwiftUI
import ComposableArchitecture

struct PhotographerMyPageView: View {
    @Bindable var store: StoreOf<MyPageFeature>

    // MARK: - Computed

    /// 인스타그램 아이디 노출 텍스트. 미등록이면 "미등록", 등록되어 있으면 "@아이디".
    private var instagramDisplayText: String {
        guard let username = store.instagramUsername?.trimmingCharacters(in: .whitespaces),
              !username.isEmpty else {
            return "미등록"
        }
        return "@\(username)"
    }

    var body: some View {
        VStack(spacing: 0) {
            profileCard
            
            Rectangle()
                .fill(Color(.pGrey2))
                .frame(height: 1)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)

            infoList

            Rectangle()
                .fill(Color(.pGrey2))
                .frame(height: 1)
                .padding(.horizontal, 16)

            actionCards
                .padding(.top, 20)
                .padding(.bottom, 50)

            Rectangle()
                .fill(Color(.pGrey1))
                .frame(height: 10)

            packagesSection

            Rectangle()
                .fill(Color(.pGrey1))
                .frame(height: 10)

            portfolioSection

            Rectangle()
                .fill(Color(.pGrey1))
                .frame(height: 10)

            satisfactionSection
        }
    }

    // MARK: - 프로필 카드

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 8) {
                // TODO: 프로필 이미지 실제 URL 로딩 적용
                Image(.profileImagePlaceholder)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(store.nickname)
                            .typo(.pSmallTitle)
                            .foregroundStyle(.pBlack)

                        Spacer()

                        Text("팔로워 \(store.followerCount)명")
                            .typo(.pCaption)
                            .foregroundStyle(.pGrey4)
                    }
                    Button {
                        store.send(.instagramLinkTapped)
                    } label: {
                        HStack(spacing: 2.5) {
                            Image(.instargram)

                            Text(instagramDisplayText)
                                .typo(.pCaption)
                                .foregroundStyle(.pBlack)
                                .underline()
                        }
                    }
                    .buttonStyle(.plain)

                    Text(store.photographerBio)
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey6)
                }
            }

            HStack(spacing: 8) {
                Button {
                    store.send(.profileEditTapped)
                } label: {
                    Text("프로필 수정")
                        .typo(.pBoldParagraph)
                        .foregroundStyle(.pGrey6)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.pGrey3), lineWidth: 1)
                        )
                }

                // 패키지 등록 전에는 프로필 미리보기 비활성화 (회색 배경 + disabled)
                Button {
                    store.send(.profilePreviewTapped)
                } label: {
                    HStack(spacing: 4) {
                        Text("프로필 미리보기")
                            .typo(.pBoldParagraph)
                            .foregroundStyle(.pGrey5)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundStyle(.pGrey5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(store.hasPackages ? Color.clear : Color(.pGrey2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(store.hasPackages ? Color(.pGrey3) : Color.clear, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .buttonStyle(.plain)
                .disabled(!store.hasPackages)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }

    // MARK: - 정보 리스트 (지역/키워드/장비)

    private var infoList: some View {
        VStack(spacing: 12) {
            infoRow(
                summary: Self.summarizeList(store.activeRegions, label: "지역"),
                actionTitle: "주 촬영지 편집"
            ) {
                store.send(.activeRegionsEditTapped)
            }

            infoRow(
                summary: Self.summarizeList(store.keywords, label: "키워드"),
                actionTitle: "키워드 편집"
            ) {
                store.send(.keywordsEditTapped)
            }

            infoRow(
                summary: Self.summarizeList(store.equipments, label: "장비"),
                actionTitle: "장비 편집"
            ) {
                store.send(.equipmentsEditTapped)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    private func infoRow(summary: AttributedString, actionTitle: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(summary)
                .typo(.pParagraph)
                .lineLimit(1)
            Spacer()
            Button(action: action) {
                Text(actionTitle)
                    .typo(.pInsideTag)
                    .foregroundStyle(.pGreen120)
                    .underline()
            }
        }
    }

    // MARK: - 액션 카드 (지난 촬영 내역 / 정산 내역)

    private var actionCards: some View {
        HStack(spacing: 10) {
            actionCard(title: "지난 촬영 내역", image: .cameraIcon) {
                store.send(.pastShootingsTapped)
            }
            actionCard(title: "정산 내역", image: .receiptIcon) {
                store.send(.settlementTapped)
            }
        }
        .padding(.horizontal, 16)
    }

    private func actionCard(title: String, image: ImageResource, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(image)
                Text(title)
                    .typo(.pBoldParagraph)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color(.pBlack))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - 촬영 패키지 섹션

    private var packagesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "촬영 패키지") {
                store.send(.packagesEditTapped)
            }

            if store.hasPackages {
                ForEach(store.packages) { package in
                    PackageCardView(package: package)
                }
            } else {
                emptyStateCard(
                    description: "아직 등록하신 패키지가 없습니다.\n우측 상단의 편집을 눌러\n새로운 패키지를 추가해 보세요."
                )

                Text("패키지를 하나 이상 등록해야\n고객들이 촬영을 예약할 수 있게 됩니다.")
                    .typo(.pBoldParagraph)
                    .foregroundStyle(.pGrey6)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }

    // MARK: - 포트폴리오 섹션

    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "포트폴리오") {
                store.send(.portfolioEditTapped)
            }

            if store.hasPortfolios {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(store.portfolios) { portfolio in
                        Button {
                            store.send(.portfolioThumbnailTapped)
                        } label: {
                            AsyncImage(url: URL(string: portfolio.imageURLs.first ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                default:
                                    Rectangle()
                                        .fill(Color(.pGrey2))
                                }
                            }
                            .frame(minHeight: 0)
                            .aspectRatio(1, contentMode: .fit)
                            .clipped()
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                emptyStateCard(
                    description: "아직 등록하신 포트폴리오가 없습니다.\n우측 상단의 편집을 눌러\n사진을 추가해 보세요."
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }

    // MARK: - 촬영 만족도 섹션

    private var satisfactionSection: some View {
        VStack(spacing: 12) {
            Text("촬영 만족도")
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)

            HStack(spacing: 6) {
                ForEach(1...5, id: \.self) { index in
                    Image(Double(index) <= store.satisfactionRating ? .starFill : .starEmpty)
                }
                Text(String(format: "%.1f", store.satisfactionRating))
                    .typo(.pParagraph)
                    .foregroundStyle(.pGrey4)
                    .padding(.leading, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }

    // MARK: - 섹션 헤더

    private func sectionHeader(title: String, onEdit: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
            Spacer()
            Button(action: onEdit) {
                Text("편집")
                    .typo(.pInsideTag)
                    .foregroundStyle(.pGreen120)
                    .underline()
            }
        }
    }

    // MARK: - 빈 상태 카드

    private func emptyStateCard(description: String) -> some View {
        ZStack(alignment: .topLeading) {
            Color(.pGrey2)
            Text(description)
                .typo(.pBigParagraph)
                .foregroundStyle(.pGrey4)
                .multilineTextAlignment(.leading)
                .padding(.top, 20)
                .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - 16자 룰 요약 (visible 최대 16자, 초과분은 "외 N개 [label]" 처리)
    // head 부분은 pBlack, "외 N개 ..." 꼬리 부분만 pGrey4로 분리 표시

    private static func summarizeList(_ items: [String], label: String, maxLength: Int = 16) -> AttributedString {
        guard !items.isEmpty else { return AttributedString() }

        var accumulated = ""
        var visibleCount = 0

        for (index, item) in items.enumerated() {
            let candidate = index == 0 ? item : "\(accumulated), \(item)"
            if candidate.count > maxLength {
                break
            }
            accumulated = candidate
            visibleCount = index + 1
        }

        // 단일 아이템이 16자를 초과하는 경우에도 최소 1개는 노출
        if visibleCount == 0 {
            accumulated = items[0]
            visibleCount = 1
        }

        let hiddenCount = items.count - visibleCount

        var head = AttributedString(accumulated)
        head.foregroundColor = Color(.pBlack)

        if hiddenCount > 0 {
            var tail = AttributedString(" 외 \(hiddenCount)개 \(label)")
            tail.foregroundColor = Color(.pGrey4)
            head.append(tail)
        }

        return head
    }
}

#Preview("비어있음") {
    ScrollView {
        PhotographerMyPageView(
            store: Store(
                initialState: MyPageFeature.State(
                    hasPhotographerInfo: true,
                    isPhotographerMode: true,
                    nickname: "가영포토",
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
                    packages: [],
                    portfolios: [],
                    satisfactionRating: 4.0
                )
            ) {
                MyPageFeature()
            }
        )
    }
}

#Preview("데이터 있음") {
    ScrollView {
        PhotographerMyPageView(
            store: Store(
                initialState: MyPageFeature.State(
                    hasPhotographerInfo: true,
                    isPhotographerMode: true,
                    nickname: "가영포토",
                    instagramUsername: "gayoung.photo",
                    photographerBio: "안녕하세요, 유가영 작가입니다.",
                    followerCount: 1234,
                    activeRegions: ["서울 마포구", "서울 용산구", "서울 강남구"],
                    keywords: ["#감성스냅", "#우정샷", "#커플샷"],
                    equipments: ["캐논 5D", "소니 A7"],
                    packages: [
                        MyPageFeature.ShootingPackage(
                            id: "1",
                            title: "남친 생기는 프사♥",
                            price: 9900,
                            coverImageURL: nil,
                            shootingDuration: "15분 이내",
                            detail: "여자친구 /남자친구 생기는 카톡포사 찍어드립니당~ 요즘 인스타그램 감성으로 이쁘게!\n사용기기: 아이폰 X / 아이폰 16pro\n베스트컷 5개정도 길이 뽑아드려요!"
                        )
                    ],
                    portfolios: [
                        MyPageFeature.Portfolio(id: "1", title: "경복궁 스타벅스", date: Date()),
                        MyPageFeature.Portfolio(id: "2", title: "홍익대학교 홍문관", date: Date()),
                        MyPageFeature.Portfolio(id: "3", title: "한강공원", date: Date()),
                        MyPageFeature.Portfolio(id: "4", title: "남산타워", date: Date())
                    ],
                    satisfactionRating: 4.8
                )
            ) {
                MyPageFeature()
            }
        )
    }
}
