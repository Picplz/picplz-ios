//
//  PortfolioListView.swift
//  Features
//

import ComposableArchitecture
import SwiftUI

struct PortfolioListView: View {
    @Bindable var store: StoreOf<PortfolioListFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(store.portfolios.enumerated()), id: \.element.id) { index, portfolio in
                        PortfolioCardView(
                            portfolio: portfolio,
                            onEditTapped: { store.send(.editTapped(portfolio)) },
                            onDeleteTapped: { store.send(.deleteRequested(portfolio.id)) }
                        )
                        .padding(.top, 12)
                        .padding(.bottom, 20)

                        if index < store.portfolios.count - 1 {
                            Rectangle()
                                .fill(Color(.pGrey2))
                                .frame(height: 1)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
        .toast(item: $store.toast)
        .picAlert(
            isPresented: $store.isDeleteAlertPresented,
            title: "정말 해당 포트폴리오를 삭제할까요?",
            message: "삭제된 포트폴리오는 다시 복원할 수 없어요.",
            cancelText: "취소",
            confirmText: "삭제",
            onCancel: { store.send(.dismissDeleteAlert) },
            onConfirm: { store.send(.confirmDelete) }
        )
    }
}

// MARK: - Portfolio Card

private struct PortfolioCardView: View {
    let portfolio: MyPageFeature.Portfolio
    let onEditTapped: () -> Void
    let onDeleteTapped: () -> Void

    @State private var currentPage: Int = 0

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. M. d"
        return formatter.string(from: portfolio.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerRow

            subtitleRow

            photoCarousel
                .padding(.top, 8)

            if portfolio.imageURLs.count > 1 {
                ScrollingPageIndicator(
                    currentPage: currentPage,
                    totalPages: portfolio.imageURLs.count
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
        }
    }

    private var headerRow: some View {
        HStack(alignment: .center) {
            Text(portfolio.title)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
                .lineLimit(1)

            Spacer()

            Menu {
                Button("수정하기") { onEditTapped() }
                Button("삭제하기", role: .destructive) { onDeleteTapped() }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.pBlack)
                    .frame(width: 28, height: 28, alignment: .center)
            }
        }
    }

    private var subtitleRow: some View {
        HStack(spacing: 8) {
            if let detail = portfolio.locationDetail, !detail.isEmpty {
                HStack(spacing: 4) {
                    Image(.locationGrayPin)

                    Text(detail)
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey3)
                        .lineLimit(1)
                }

                Text("|")
                    .typo(.pCaption)
                    .foregroundStyle(.pGrey3)
            }

            Text(dateText)
                .typo(.pCaption)
                .foregroundStyle(.pGrey3)

            Spacer()
        }
    }

    private var photoCarousel: some View {
        Group {
            if portfolio.imageURLs.isEmpty {
                Rectangle()
                    .fill(Color(.pGrey2))
                    .frame(height: 428)
            } else {
                TabView(selection: $currentPage) {
                    ForEach(Array(portfolio.imageURLs.enumerated()), id: \.offset) { index, url in
                        AsyncImage(url: URL(string: url)) { phase in
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
                        .clipped()
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 428)
            }
        }
    }
}

private func previewDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

#Preview("데이터 있음") {
    PortfolioListView(
        store: Store(
            initialState: PortfolioListFeature.State(
                portfolios: [
                    MyPageFeature.Portfolio(
                        id: "1",
                        title: "경복궁 스타벅스",
                        locationDetail: "서울 마포구 와우산로 어쩌고",
                        date: previewDate(2024, 12, 24),
                        imageURLs: []
                    ),
                    MyPageFeature.Portfolio(
                        id: "2",
                        title: "홍익대학교 홍문관",
                        locationDetail: nil,
                        date: previewDate(2024, 11, 12),
                        imageURLs: []
                    )
                ],
                toast: ToastItem(message: "포트폴리오가 등록되었습니다.")
            )
        ) {
            PortfolioListFeature()
        }
    )
}

#Preview("사진 여러장") {
    PortfolioListView(
        store: Store(
            initialState: PortfolioListFeature.State(
                portfolios: [
                    MyPageFeature.Portfolio(
                        id: "1",
                        title: "경복궁 스타벅스",
                        locationDetail: "서울 마포구 와우산로 어쩌고",
                        date: previewDate(2024, 12, 24),
                        imageURLs: ["img1", "img2", "img3", "img4"]
                    ),
                    MyPageFeature.Portfolio(
                        id: "2",
                        title: "홍익대학교 홍문관",
                        locationDetail: nil,
                        date: previewDate(2024, 11, 12),
                        imageURLs: ["img1", "img2", "img3", "img4", "img5", "img6", "img7"]
                    ),
                    MyPageFeature.Portfolio(
                        id: "3",
                        title: "한강공원",
                        locationDetail: "서울 영등포구 여의동로",
                        date: previewDate(2024, 10, 5),
                        imageURLs: ["img1", "img2"]
                    )
                ]
            )
        ) {
            PortfolioListFeature()
        }
    )
}

#Preview("비어있음") {
    PortfolioListView(
        store: Store(
            initialState: PortfolioListFeature.State()
        ) {
            PortfolioListFeature()
        }
    )
}
