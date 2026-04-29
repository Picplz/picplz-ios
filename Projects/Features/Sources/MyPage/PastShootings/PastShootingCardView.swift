//
//  PastShootingCardView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI

struct PastShootingCardView: View {
    let shooting: PastShootingsFeature.PastShooting
    let onChatTapped: () -> Void
    let onReviewTapped: () -> Void
    let onOrderDetailTapped: () -> Void

    private var isCancelled: Bool {
        shooting.status == .cancelled
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: 카드 상단 (촬영 취소 시 핑크 배경)
            VStack(alignment: .leading, spacing: 12) {
                // 작가 정보 + 결제 날짜
                HStack {
                    Image(.profileImagePlaceholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())

                    Text(shooting.photographerName)
                        .typo(.pBoldParagraph)
                        .foregroundStyle(.pBlack)

                    Spacer()

                    Text(shooting.paymentDate)
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey3)

                    Text("결제")
                        .typo(.pCaption)
                        .foregroundStyle(.pGrey3)
                }

                // 촬영명
                Text(shooting.title)
                    .typo(.pParagraph)
                    .foregroundStyle(.pBlack)

                // 가격 + 상태 뱃지
                HStack(spacing: 8) {
                    Text("\(shooting.price.formatted())원")
                        .typo(.pSmallTitle)
                        .foregroundStyle(.pBlack)
                        .strikethrough(isCancelled)

                    Text(shooting.status.rawValue)
                        .typo(.pCaption)
                        .foregroundStyle(isCancelled ? Color(.pRed) : Color(.pGreen120))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isCancelled ? Color(.pPink1) : Color(.pGreen30))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isCancelled ? Color(.pPink2) : Color(.pGreen100), lineWidth: 1)
                        )
                }
            }
            .padding(16)
            
            Rectangle()
                .fill(Color(.pGrey2))
                .frame(height: 1)
                .padding(.horizontal, 16)

            // MARK: 촬영 정보
            VStack(alignment: .leading, spacing: 8) {
                // 촬영 일시
                HStack(spacing: 4) {
                    Text("촬영 일시")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                        .padding(.trailing, 10)
                    Text(shooting.dateTime)
                        .typo(.pBoldParagraph)
                        .foregroundStyle(.pBlack)
                    Spacer()
                }

                // 촬영 장소
                HStack(alignment: .top, spacing: 4) {
                    Text("촬영 장소")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                        .padding(.trailing, 10)
                    Text(shooting.location)
                        .typo(.pBoldParagraph)
                        .foregroundStyle(.pBlack)
                    Spacer()
                }

                // 주문 상세보기
                HStack {
                    Spacer()
                    Button {
                        onOrderDetailTapped()
                    } label: {
                        HStack(spacing: 2) {
                            Text("주문 상세보기")
                                .typo(.pCaption)
                                .foregroundStyle(.pGrey4)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(.pGrey4)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // MARK: 버튼 영역
            HStack(spacing: 8) {
                Button {
                    onChatTapped()
                } label: {
                    Text("채팅 가기")
                        .typo(.pParagraph)
                        .foregroundStyle(.pBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.pGrey3), lineWidth: 1)
                        )
                }

                if !isCancelled {
                    Button {
                        onReviewTapped()
                    } label: {
                        Text("리뷰 쓰기")
                            .typo(.pParagraph)
                            .foregroundStyle(.pBlack)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(.pGrey3), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(16)
        }
        .background(Color(.pWhite))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.pGrey2), lineWidth: 1)
        )
    }
}

#Preview("촬영 취소") {
    PastShootingCardView(
        shooting: PastShootingsFeature.PastShooting(
            id: "1",
            photographerName: "합정동작가",
            photographerImageURL: nil,
            title: "남친생기는 프사",
            price: 12000,
            status: .cancelled,
            dateTime: "25.03.24 오후2:30",
            location: "종로구 효자로 33 어디어디 어디어디 어디 어디 어디어디빌딩 뭐뭐",
            paymentDate: "2025.03.01"
        ),
        onChatTapped: {},
        onReviewTapped: {},
        onOrderDetailTapped: {}
    )
    .padding(.horizontal, 16)
}

#Preview("촬영 완료") {
    PastShootingCardView(
        shooting: PastShootingsFeature.PastShooting(
            id: "2",
            photographerName: "유가영사진",
            photographerImageURL: nil,
            title: "인스타 피드꾸미기",
            price: 12000,
            status: .completed,
            dateTime: "25.03.24 오후2:30",
            location: "종로구 효자로 33 어디어디 어디",
            paymentDate: "2025.03.01"
        ),
        onChatTapped: {},
        onReviewTapped: {},
        onOrderDetailTapped: {}
    )
    .padding(.horizontal, 16)
}
