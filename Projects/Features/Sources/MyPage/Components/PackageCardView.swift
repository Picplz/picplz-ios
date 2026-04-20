//
//  PackageCardView.swift
//  Features
//
//  Created by wonsik on 4/20/26.
//

import SwiftUI

struct PackageCardView: View {
    let package: MyPageFeature.ShootingPackage

    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: package.price)) ?? "\(package.price)"
        return "\(formatted)원"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            coverImage

            VStack(alignment: .leading, spacing: 4) {
                Text(package.title)
                    .typo(.pTitle)
                    .foregroundStyle(.pBlack)

                Text(formattedPrice)
                    .typo(.pSmallTitle)
                    .foregroundStyle(.pBlack)
            }
            .padding(.top, 12)
            .padding(.bottom, 16)

            detailInfo
                .padding(.top, 12)
        }
    }

    // MARK: - 커버 이미지

    private var coverImage: some View {
        Group {
            if let imageURL = package.coverImageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        coverPlaceholder
                    }
                }
            } else {
                coverPlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private var coverPlaceholder: some View {
        Rectangle()
            .fill(Color(.pGrey2))
            .overlay {
                Image(.profileImagePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
    }

    // MARK: - 상세 정보

    private var detailInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !package.shootingDuration.isEmpty {
                detailRow(label: "촬영 시간", value: package.shootingDuration)
            }
            if !package.detail.isEmpty {
                detailRow(label: "기타 안내", value: package.detail)
            }
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .typo(.pBoldParagraph)
                .foregroundStyle(.pGrey6)
                .fixedSize()

            Text(value)
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    PackageCardView(
        package: MyPageFeature.ShootingPackage(
            id: "1",
            title: "남친 생기는 프사♥",
            price: 9900,
            coverImageURL: nil,
            shootingDuration: "15분 이내",
            detail: "여자친구 /남자친구 생기는 카톡포사 찍어드립니당~ 요즘 인스타그램 감성으로 이쁘게!\n사용기기: 아이폰 X / 아이폰 16pro\n베스트컷 5개정도 길이 뽑아드려용!"
        )
    )
    .padding(.horizontal, 16)
}
