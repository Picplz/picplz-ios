//
//  ReviewDetailView.swift
//  Features
//
//  Created by wonsik on 4/7/26.
//

import SwiftUI
import ComposableArchitecture

struct ReviewDetailView: View {
    let store: StoreOf<ReviewDetailFeature>
    @State private var selectedImageIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 작가 정보 + 삭제/날짜
                    HStack(alignment: .top) {
                        HStack(spacing: 8) {
                            // TODO: 유저 프로필 이미지 실제 URL 로딩 적용
                            Circle()
                                .fill(Color(.pGrey2))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(.profileImagePlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color(.pBlack), lineWidth: 1)
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                Text(store.review.reviewerName)
                                    .typo(.pBoldParagraph)
                                    .foregroundStyle(.pBlack)

                                HStack(spacing: 2) {
                                    ForEach(1...5, id: \.self) { index in
                                        Image(index <= store.review.rating ? .starFill : .starEmpty)
                                    }
                                }
                            }
                        }

                        Spacer()

                        HStack(spacing: 8) {
                            Button {
                                store.send(.deleteTapped)
                            } label: {
                                Text("삭제")
                                    .typo(.pCaption)
                                    .foregroundStyle(.pWhite)
                                    .padding(.horizontal, 4.5)
                                    .padding(.vertical, 1.5)
                                    .background(Color(.pRed))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }

                            Text(store.review.date + " 작성")
                                .typo(.pCaption)
                                .foregroundStyle(.pBlack)
                        }
                    }
                    .padding(.horizontal, 16)

                    // 사진 (페이지 형태)
                    if !store.review.imageURLs.isEmpty {
                        TabView(selection: $selectedImageIndex) {
                            ForEach(Array(store.review.imageURLs.enumerated()), id: \.offset) { index, _ in
                                // TODO: 실제 이미지 URL 로딩 적용
                                Rectangle()
                                    .fill(Color(.pGrey2))
                                    .overlay(alignment: .topTrailing) {
                                        Text("\(index + 1)/\(store.review.imageURLs.count)")
                                            .typo(.pCaption)
                                            .foregroundStyle(.pGrey2)
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 2)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .padding(.top, 12)
                                            .padding(.trailing, 12)
                                    }
                                    .padding(.horizontal, 16)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 343)

                        // 페이지 인디케이터
                        ScrollingPageIndicator(
                            currentPage: selectedImageIndex,
                            totalPages: store.review.imageURLs.count
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        // 작가 이름 (탭 가능)
                        Button {
                            store.send(.photographerTapped)
                        } label: {
                            HStack(spacing: 6) {
                                // TODO: 작가 프로필 이미지 실제 URL 로딩 적용
                                Circle()
                                    .fill(Color(.pGrey2))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(.profileImagePlaceholder)	
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.pGrey2), lineWidth: 1)
                                    )

                                Text(store.review.photographerName)
                                    .typo(.pButtonNormalLabel)
                                    .foregroundStyle(.pBlack)

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.pGrey4)
                            }
                        }

                        // 옵션 + 촬영지
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("옵션")
                                    .typo(.pInsideTag)
                                    .foregroundStyle(.pGrey4)
                                Text(store.review.option)
                                    .typo(.pCaption)
                                    .foregroundStyle(.pGrey4)
                            }

                            HStack(spacing: 8) {
                                Text("촬영지")
                                    .typo(.pInsideTag)
                                    .foregroundStyle(.pGrey4)
                                Text(store.review.location)
                                    .typo(.pCaption)
                                    .foregroundStyle(.pGrey4)
                                
                                Spacer()
                                
                                // 좋아요
                                Button {
                                    store.send(.likeTapped)
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(.like)
                                        Text("\(store.review.likeCount)")
                                            .typo(.pCaption)
                                            .foregroundStyle(.pBlack)
                                    }
                                }
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.pGrey2)
                            .padding(.vertical, 20)

                        // 리뷰 본문
                        Text(store.review.content)
                            .typo(.pParagraph)
                            .foregroundStyle(.pBlack)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)
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

#Preview("이미지 3개") {
    ReviewDetailView(
        store: Store(
            initialState: ReviewDetailFeature.State(
                review: MyReviewsFeature.MyReview(
                    id: "1",
                    reviewerName: "합정동 불주먹",
                    reviewerImageURL: nil,
                    photographerName: "유가영 작가",
                    photographerImageURL: nil,
                    rating: 4,
                    date: "2024.12.03",
                    imageURLs: ["img1", "img2", "img3"],
                    option: "프로필 Only",
                    location: "서울시 마포구 무대륙",
                    content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
                    likeCount: 4
                )
            )
        ) {
            ReviewDetailFeature()
        }
    )
}

#Preview("이미지 7개") {
    ReviewDetailView(
        store: Store(
            initialState: ReviewDetailFeature.State(
                review: MyReviewsFeature.MyReview(
                    id: "2",
                    reviewerName: "합정동 불주먹",
                    reviewerImageURL: nil,
                    photographerName: "유가영 작가",
                    photographerImageURL: nil,
                    rating: 5,
                    date: "2024.12.03",
                    imageURLs: ["img1", "img2", "img3", "img4", "img5", "img6", "img7"],
                    option: "프로필 Only",
                    location: "서울시 마포구 무대륙",
                    content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다!",
                    likeCount: 12
                )
            )
        ) {
            ReviewDetailFeature()
        }
    )
}
