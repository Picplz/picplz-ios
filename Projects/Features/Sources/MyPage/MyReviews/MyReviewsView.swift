//
//  MyReviewsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct MyReviewsView: View {
    let store: StoreOf<MyReviewsFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "리뷰") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            if store.reviews.isEmpty {
                EmptyStateView(
                    title: "아직 작성한 리뷰가 없어요",
                    description: "촬영을 진행하고\n리뷰를 작성해 보세요"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(store.reviews) { review in
                            MyReviewCardView(
                                review: review,
                                onDeleteTapped: {
                                    store.send(.deleteTapped(review))
                                },
                                onLikeTapped: {
                                    store.send(.likeTapped(review))
                                },
                                onTap: {
                                    store.send(.reviewTapped(review))
                                }
                            )
                            .padding(.horizontal, 16)

                            Rectangle()
                                .fill(Color(.pGrey2))
                                .frame(height: 1)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .picAlert(
            isPresented: Binding(
                get: { store.showDeleteAlert },
                set: { _ in store.send(.dismissDeleteAlert) }
            ),
            title: "리뷰를 삭제하시겠습니까?",
            message: "삭제된 리뷰는\n되돌릴 수 없습니다.",
            onConfirm: {
                store.send(.confirmDelete)
            }
        )
    }
}

#Preview("List") {
    MyReviewsView(
        store: Store(
            initialState: MyReviewsFeature.State(
                reviews: [
                    .init(
                        id: "1",
                        reviewerName: "합정동 불주먹",
                        reviewerImageURL: nil,
                        photographerName: "유가영 작가",
                        photographerImageURL: nil,
                        rating: 1,
                        date: "2024.12.03",
                        imageURLs: ["img1", "img2", "img3"],
                        option: "남친생기는 프사",
                        location: "서울시 마포구 무대륙",
                        content: "아 ㅣ 개별로에요 다시는 이사람한테 안찍음 ——"
                    ),
                    .init(
                        id: "2",
                        reviewerName: "합정동 불주먹",
                        reviewerImageURL: nil,
                        photographerName: "유가영 작가",
                        photographerImageURL: nil,
                        rating: 4,
                        date: "2024.12.03",
                        imageURLs: ["img1", "img2"],
                        option: "남친생기는 프사",
                        location: "서울시 마포구 무대륙",
                        content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!"
                    ),
                    .init(
                        id: "3",
                        reviewerName: "합정동 불주먹",
                        reviewerImageURL: nil,
                        photographerName: "유가영 작가",
                        photographerImageURL: nil,
                        rating: 3,
                        date: "2024.12.03",
                        imageURLs: [],
                        option: "인스타 감성",
                        location: "서울시 강남구 역삼동",
                        content: "보통이에요"
                    ),
                ]
            )
        ) {
            MyReviewsFeature()
        }
    )
}

#Preview("Empty") {
    MyReviewsView(
        store: Store(
            initialState: MyReviewsFeature.State(reviews: [])
        ) {
            MyReviewsFeature()
        }
    )
}
