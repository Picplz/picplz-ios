//
//  PhotographerDetailView.swift
//  Features
//

import ComposableArchitecture
import SwiftUI

struct PhotographerDetailView: View {
    @Bindable var store: StoreOf<PhotographerDetailFeature>

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
                .padding(.horizontal, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    profileSection
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                    tagsSection
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 24)

                    sectionDivider

                    satisfactionSection
                        .padding(.top, 28)
                        .padding(.bottom, 16)

                    if let review = store.representativeReview {
                        reviewCard(review)
                            .padding(.horizontal, 16)

                        viewAllReviewsLink
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, 28)
                    } else {
                        Spacer().frame(height: 12)
                    }

                    sectionDivider

                    portfolioSection
                        .padding(.top, 24)
                        .padding(.bottom, 24)

                    sectionDivider

                    packagesSection
                        .padding(.top, 24)
                        .padding(.bottom, 24)
                }
            }

            reservationCTA
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
        }
        .navigationBarHidden(true)
    }

    // MARK: - 상단 내비게이션

    private var navigationBar: some View {
        ZStack {
            Text(store.nickname)
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)

            HStack {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.pBlack)
                        .frame(width: 28, height: 28, alignment: .center)
                }

                Spacer()

                Button {
                    store.send(.kebabMenuTapped)
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.pBlack)
                        .frame(width: 28, height: 28, alignment: .center)
                }
            }
        }
        .frame(height: 44)
    }

    // MARK: - 프로필 섹션

    private var profileSection: some View {
        HStack(alignment: .top, spacing: 8) {
            // TODO: profileImageURL 적용
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

                    Text("\(store.followerCount)명")
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey4)

                    followButton
                }

                if let username = store.instagramUsername?.trimmingCharacters(in: .whitespaces),
                   !username.isEmpty {
                    Button {
                        store.send(.instagramLinkTapped)
                    } label: {
                        HStack(spacing: 2.5) {
                            Image(.instargram)
                            Text("\(username)")
                                .typo(.pCaption)
                                .foregroundStyle(.pBlack)
                                .underline()
                        }
                    }
                    .buttonStyle(.plain)
                }

                Text(store.photographerBio)
                    .typo(.pCaption)
                    .foregroundStyle(.pGrey6)
                    .lineLimit(2)
            }
        }
    }

    private var followButton: some View {
        Button {
            store.send(.followTapped)
        } label: {
            Text(store.isFollowing ? "팔로우 중" : "팔로우 +")
                .typo(.pCaption)
                .foregroundStyle(store.isFollowing ? .pGrey4 : .pGrey3)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(store.isFollowing ? .pGrey3 : .pGrey2), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 태그 행 (촬영지/키워드/장비)

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            tagRow(label: "촬영지", items: store.activeRegions)
            tagRow(label: "키워드", items: store.keywords)
            tagRow(label: "장비", items: store.equipments)
        }
    }

    private func tagRow(label: String, items: [String]) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)
                .frame(width: 40, alignment: .leading)

            Text(Self.summarize(items))
                .typo(.pCaption)
                .foregroundStyle(.pGrey6)
                .lineLimit(1)
        }
    }

    private static func summarize(_ items: [String], maxLength: Int = 16) -> AttributedString {
        guard !items.isEmpty else { return AttributedString() }

        var accumulated = ""
        var visibleCount = 0

        for (index, item) in items.enumerated() {
            let candidate = index == 0 ? item : "\(accumulated), \(item)"
            if candidate.count > maxLength { break }
            accumulated = candidate
            visibleCount = index + 1
        }

        if visibleCount == 0 {
            accumulated = items[0]
            visibleCount = 1
        }

        let hiddenCount = items.count - visibleCount

        var head = AttributedString(accumulated)
        head.foregroundColor = Color(.pBlack)

        if hiddenCount > 0 {
            var tail = AttributedString(" 외 \(hiddenCount)개")
            tail.foregroundColor = Color(.pGrey4)
            head.append(tail)
        }

        return head
    }

    // MARK: - 촬영 만족도

    private var satisfactionSection: some View {
        VStack(spacing: 8) {
            Text("촬영 만족도")
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)

            HStack(spacing: 6) {
                ForEach(1...5, id: \.self) { index in
                    Image(Double(index) <= store.satisfactionRating ? .starFill : .starEmpty)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Text(String(format: "%.1f", store.satisfactionRating))
                    .typo(.pBoldParagraph)
                    .foregroundStyle(.pGrey4)
                    .padding(.leading, 4)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 대표 리뷰 카드

    private func reviewCard(_ review: MyReviewsFeature.MyReview) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(.pGrey2))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(.profileImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                        )
                        .overlay(Circle().stroke(Color(.pBlack), lineWidth: 1))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(review.reviewerName)
                            .typo(.pBoldParagraph)
                            .foregroundStyle(.pBlack)

                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { index in
                                Image(index <= review.rating ? .starFill : .starEmpty)
                            }
                        }
                    }
                }

                Spacer()

                Text(review.date)
                    .typo(.pCaption)
                    .foregroundStyle(.pBlack)
            }

            if !review.imageURLs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(Array(review.imageURLs.enumerated()), id: \.offset) { _, _ in
                            // TODO: 실제 이미지 URL 로딩 적용
                            Rectangle()
                                .fill(Color(.pGrey2))
                                .frame(width: 113, height: 113)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("옵션")
                        .typo(.pInsideTag)
                        .foregroundStyle(.pGrey4)
                    Text(review.option)
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey4)
                }

                HStack(spacing: 8) {
                    Text("촬영지")
                        .typo(.pInsideTag)
                        .foregroundStyle(.pGrey4)
                    Text(review.location)
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey4)
                }
            }

            Text(review.content)
                .typo(.pParagraph)
                .foregroundStyle(.pBlack)
                .lineLimit(2)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
        }
    }

    private var viewAllReviewsLink: some View {
        Button {
            store.send(.viewAllReviewsTapped)
        } label: {
            HStack(spacing: 4) {
                Spacer()
                Text("전체 리뷰 보러가기 (\(store.reviews.count))")
                    .typo(.pCaption)
                    .foregroundStyle(.pGrey4)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.pGrey4)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - 포트폴리오 섹션

    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("포트폴리오")
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
                .padding(.horizontal, 16)

            if store.portfolios.isEmpty {
                EmptyView()
            } else {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(store.displayedPortfolios) { portfolio in
                        Button {
                            store.send(.portfolioTapped(portfolio.id))
                        } label: {
                            AsyncImage(url: URL(string: portfolio.imageURLs.first ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                default:
                                    Rectangle().fill(Color(.pGrey2))
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(minHeight: 0)
                            .clipped()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)

                if store.hasMorePortfolios {
                    Button {
                        store.send(.viewAllPortfoliosTapped)
                    } label: {
                        HStack(spacing: 4) {
                            Spacer()
                            Text("포트폴리오 더 보기")
                                .typo(.pCaption)
                                .foregroundStyle(.pGrey4)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(.pGrey4)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
    }

    // MARK: - 촬영 패키지 섹션

    private var packagesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("촬영 패키지")
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)

            ForEach(store.packages) { package in
                Button {
                    store.send(.packageTapped(package.id))
                } label: {
                    PackageCardView(package: package)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - 섹션 구분 (두꺼운 회색 바)

    private var sectionDivider: some View {
        Rectangle()
            .fill(Color(.pGrey1))
            .frame(height: 10)
    }

    // MARK: - 하단 CTA

    private var reservationCTA: some View {
        Button {
            if store.isAcceptingReservation {
                store.send(.reservationTapped)
            }
        } label: {
            Text(store.isAcceptingReservation ? "예약하기" : "현재 예약을 받지 않아요")
                .typo(.pBoldParagraph)
                .foregroundStyle(store.isAcceptingReservation ? .pWhite : .pGrey5)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(store.isAcceptingReservation ? .pBlack : .pGrey2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .buttonStyle(.plain)
        .disabled(!store.isAcceptingReservation)
    }
}

#Preview("예약 가능") {
    PhotographerDetailView(
        store: Store(
            initialState: PhotographerDetailFeature.State(
                nickname: "유가영 작가",
                profileImageURL: nil,
                instagramUsername: "Gayoung",
                photographerBio: "10/31 이후 반약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다.",
                followerCount: 112,
                activeRegions: ["마포구", "동작구", "여의주", "강남구", "송파구", "종로구", "용산구", "서초구"],
                keywords: ["#브랜뉴썸", "#고급비"],
                equipments: ["아이폰 16 PRO", "갤럭시X23 울트라"],
                satisfactionRating: 4.5,
                reviews: [
                    MyReviewsFeature.MyReview(
                        id: "1",
                        reviewerName: "합정동 불주먹",
                        reviewerImageURL: nil,
                        photographerName: "유가영 작가",
                        photographerImageURL: nil,
                        rating: 4,
                        date: "2024.12.03",
                        imageURLs: ["img1", "img2", "img3"],
                        option: "남친생기는 프사",
                        location: "서울시 마포구 무대륙",
                        content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!"
                    ),
                    MyReviewsFeature.MyReview(
                        id: "2",
                        reviewerName: "다른 리뷰어",
                        reviewerImageURL: nil,
                        photographerName: "유가영 작가",
                        photographerImageURL: nil,
                        rating: 5,
                        date: "2024.11.20",
                        imageURLs: [],
                        option: "프로필 Only",
                        location: "서울시 강남구",
                        content: "정말 만족스러웠어요!"
                    )
                ],
                portfolios: (1...10).map {
                    MyPageFeature.Portfolio(id: "p\($0)", title: "포트폴리오 \($0)", date: Date())
                },
                packages: [
                    MyPageFeature.ShootingPackage(
                        id: "1",
                        title: "남친 생기는 프사♥",
                        price: 9900,
                        coverImageURL: nil,
                        shootingDuration: "15분 이내",
                        detail: "여자친구 /남자친구 생기는 카톡포사 찍어드립니당~"
                    ),
                    MyPageFeature.ShootingPackage(
                        id: "2",
                        title: "웨딩 아이폰 스냅📸",
                        price: 12900,
                        coverImageURL: nil,
                        shootingDuration: "30분 이내",
                        detail: "감성 넘치는 프로필 사진 찍어드립니다!"
                    )
                ],
                isFollowing: true,
                isAcceptingReservation: true
            )
        ) {
            PhotographerDetailFeature()
        }
    )
}

#Preview("예약 불가") {
    PhotographerDetailView(
        store: Store(
            initialState: PhotographerDetailFeature.State(
                nickname: "유가영 작가",
                profileImageURL: nil,
                instagramUsername: "Gayoung",
                photographerBio: "10/31 이후 반약 가능합니다.",
                followerCount: 112,
                activeRegions: ["마포구", "동작구", "여의주"],
                keywords: ["#감성스냅"],
                equipments: ["아이폰 16 PRO"],
                satisfactionRating: 4.5,
                reviews: [],
                portfolios: [],
                packages: [],
                isFollowing: false,
                isAcceptingReservation: false
            )
        ) {
            PhotographerDetailFeature()
        }
    )
}
