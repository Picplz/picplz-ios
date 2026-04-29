//
//  FollowedArtistCardView.swift
//  Features
//
//  Created by wonsik on 4/7/26.
//

import SwiftUI

struct FollowedArtistCardView: View {
    let artist: FollowedArtistsFeature.FollowedArtist
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                // TODO: 작가 프로필 이미지 실제 URL 로딩 적용
                // 아래 placeholder를 URL 이미지로 교체:
                // AsyncImage(url: URL(string: artist.profileImageURL ?? "")) { image in
                //     image.resizable().scaledToFill()
                // } placeholder: {
                //     Color(.pGrey2)
                // }
                // .frame(width: 88, height: 88)
                // .clipShape(RoundedRectangle(cornerRadius: 5))
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.pGrey2))
                    .frame(width: 88, height: 88)
                    .overlay(
                        Image(.profileImagePlaceholder)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    )

                // 작가 정보
                VStack(alignment: .leading, spacing: 6) {
                    // 이름 + 바로촬영 뱃지
                    HStack {
                        Text(artist.name)
                            .typo(.pBoldParagraph)
                            .foregroundStyle(.pBlack)

                        Spacer()

                        if artist.isAvailableNow {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color(.pGreen120))
                                    .frame(width: 10, height: 10)

                                Text("바로촬영")
                                    .typo(.pCaption)
                                    .foregroundStyle(.pGreen120)
                            }
                        }
                    }

                    // 활동 지역
                    Text(artist.areas.joined(separator: ", "))
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                        .lineLimit(1)

                    // 컨셉 태그
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(artist.concepts, id: \.self) { concept in
                                Text("#\(concept)")
                                    .typo(.pCaption)
                                    .foregroundStyle(.pGrey4)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(.pGrey1))
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 128, alignment: .leading)
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        FollowedArtistCardView(
            artist: FollowedArtistsFeature.FollowedArtist(
                id: "1",
                name: "유가영 작가",
                profileImageURL: nil,
                areas: ["마포구", "서대문구"],
                concepts: ["을지로 감성", "MZ 감성", "MZ 감성"],
                isAvailableNow: true
            ),
            onTap: {}
        )

        FollowedArtistCardView(
            artist: FollowedArtistsFeature.FollowedArtist(
                id: "2",
                name: "유가영 작가",
                profileImageURL: nil,
                areas: ["동작구", "영등포구"],
                concepts: ["을지로 감성", "MZ 감성", "MZ 감성"],
                isAvailableNow: false
            ),
            onTap: {}
        )
    }
    .padding(.horizontal, 16)
}
