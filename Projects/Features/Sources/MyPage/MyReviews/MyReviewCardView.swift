//
//  MyReviewCardView.swift
//  Features
//
//  Created by wonsik on 4/7/26.
//

import SwiftUI

struct MyReviewCardView: View {
    let review: MyReviewsFeature.MyReview
    let onDeleteTapped: () -> Void
    let onLikeTapped: () -> Void
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // 작가 정보 + 삭제/날짜
                HStack(alignment: .top) {
                    // 프로필 + 작가명 + 별점
                    HStack(spacing: 8) {
                        // TODO: 작가 프로필 이미지 실제 URL 로딩 적용
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
                            Text(review.reviewerName)
                                .typo(.pBoldParagraph)
                                .foregroundStyle(.pBlack)

                            // 별점
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { index in
                                    Image(index <= review.rating ? .starFill : .starEmpty)
                                }
                            }
                        }
                    }

                    Spacer()

                    // 삭제 버튼 + 날짜
                    HStack(spacing: 8) {
                        Button {
                            onDeleteTapped()
                        } label: {
                            Text("삭제")
                                .typo(.pCaption)
                                .foregroundStyle(.pWhite)
                                .padding(.horizontal, 4.5)
                                .padding(.vertical, 1.5)
                                .background(Color(.pRed))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }

                        Text(review.date)
                            .typo(.pCaption)
                            .foregroundStyle(.pBlack)
                    }
                }

                // 사진 목록
                if !review.imageURLs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            ForEach(Array(review.imageURLs.enumerated()), id: \.offset) { _, _ in
                                // TODO: 실제 이미지 URL 로딩 적용
                                Rectangle()
                                    .fill(Color(.pGrey2))
                                    .frame(width: 113, height: 113)
                            }
                        }
                    }
                }

                // 옵션 + 촬영지
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

                // 리뷰 본문
                Text(review.content)
                    .typo(.pParagraph)
                    .foregroundStyle(.pBlack)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Spacer()
                    
                    Button {
                        onLikeTapped()
                    } label: {
                        HStack(spacing: 4) {
                            Image(.like)
                            Text("\(review.likeCount)")
                                .typo(.pCaption)
                                .foregroundStyle(.pBlack)
                        }
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        MyReviewCardView(
            review: MyReviewsFeature.MyReview(
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
            onDeleteTapped: {},
            onLikeTapped: {},
            onTap: {}
        )

        Rectangle()
            .fill(Color(.pGrey2))
            .frame(height: 1)

        MyReviewCardView(
            review: MyReviewsFeature.MyReview(
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
                content: "하나하나 신경써서 해주시고 잘 알려주세요 사진 처음찍거나 잘 못찍으시는 분들 하시면 후회 안하십니다 하나하나 신경써서 찍어주시고 어쩌구저쩌구"
            ),
            onDeleteTapped: {},
            onLikeTapped: {},
            onTap: {}
        )
    }
    .padding(.horizontal, 16)
}
