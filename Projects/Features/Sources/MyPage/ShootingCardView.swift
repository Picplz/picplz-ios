//
//  ShootingCardView.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import SwiftUI

/// 진행중인 촬영 카드 뷰
/// - 작가 프로필 + 예약 상태 뱃지
/// - 촬영명 (1줄, 말줄임)
/// - 촬영 일시 / 장소
struct ShootingCardView: View {
    let shooting: MyPageFeature.ActiveShooting
    let onTap: () -> Void

    var body: some View {
        // TODO: 작가 프로필 이미지 실제 URL 로딩 적용
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // 작가 정보 + 상태 뱃지
                HStack(spacing: 6) {
                    Image(.profileImagePlaceholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(shooting.photographerName)
                            .typo(.pBoldParagraph)
                            .foregroundStyle(.pBlack)

                        Text(shooting.status)
                            .typo(.pCaption)
                            .foregroundStyle(.pGreen120)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Color(.pGreen30))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(.pGreen100), lineWidth: 1)
                            )
                    }
                }

                // 촬영명
                Text(shooting.title)
                    .typo(.pTitle)
                    .foregroundStyle(.pBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.pGrey2)

                // 촬영 일시
                HStack(spacing: 4) {
                    Image(.myPageTime)
                        .frame(width: 14, height: 14)
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
                HStack(spacing: 4) {
                    Image(.myPageLocation)
                        .frame(width: 14, height: 14)
                    Text("촬영 장소")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                        .padding(.trailing, 10)
                    Text(shooting.location)
                        .typo(.pBoldParagraph)
                        .foregroundStyle(.pBlack)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(Color(.pGrey1))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.pGrey2), lineWidth: 1)
            )
        }
    }
}
