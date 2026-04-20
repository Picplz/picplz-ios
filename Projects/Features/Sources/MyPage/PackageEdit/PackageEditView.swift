//
//  PackageEditView.swift
//  Features
//
//  Created by wonsik on 4/20/26.
//

import SwiftUI
import ComposableArchitecture

struct PackageEditView: View {
    let store: StoreOf<PackageEditFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "촬영 패키지 편집") {
                store.send(.backButtonTapped)
            }
            .padding(.horizontal, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("내 상품 목록")
                        .typo(.pSmallTitle)
                        .foregroundStyle(.pBlack)

                    addPackageCard {
                        store.send(.addPackageTapped)
                    }

                    ForEach(store.packages) { package in
                        editPackageCard(package: package)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if store.isMenuPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        store.send(.menuDismissed)
                    }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if store.isMenuPresented {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color(.pGrey2))
                        .frame(width: 40, height: 4)
                        .padding(.top, 10)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)

                    Button {
                        store.send(.editPackageTapped)
                    } label: {
                        Text("상품 수정하기")
                            .typo(.pBigParagraph)
                            .foregroundStyle(.pBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 18)
                    }
                    
                    Rectangle()
                        .fill(Color(.pGrey2))
                        .frame(height: 1)

                    Button {
                        store.send(.deletePackageTapped)
                    } label: {
                        Text("상품 삭제하기")
                            .typo(.pBigParagraph)
                            .foregroundStyle(.pRed)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 18)
                    }
                }
                .padding(.bottom, 20)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20
                    )
                    .fill(Color(.pWhite))
                    .ignoresSafeArea(edges: .bottom)
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: store.isMenuPresented)
    }

    // MARK: - 추가 카드

    private func addPackageCard(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text("상품을 추가하세요")
                    .typo(.pButtonNormalLabel)
                    .foregroundStyle(.pGrey4)

                Image(systemName: "plus")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(.pGrey3)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 343)
            .background(Color(.pGrey1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    // MARK: - 패키지 카드 (편집용)

    private func editPackageCard(package: MyPageFeature.ShootingPackage) -> some View {
        let formatter: NumberFormatter = {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            return f
        }()
        let priceText = (formatter.string(from: NSNumber(value: package.price)) ?? "\(package.price)") + "원"

        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(package.title)
                    .typo(.pSmallTitle)
                    .foregroundStyle(.pBlack)

                Spacer()

                Button {
                    store.send(.packageMenuTapped(package.id))
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.pBlack)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 23)
            .padding(.bottom, 12)

            coverImage(url: package.coverImageURL)
                .padding(.horizontal, 22)
                .padding(.bottom, 12)

            Text(priceText)
                .typo(.pTitle)
                .foregroundStyle(.pBlack)
                .padding(.horizontal, 22)
                .padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 6) {
                if !package.shootingDuration.isEmpty {
                    detailRow(label: "촬영 시간", value: package.shootingDuration)
                }
                if !package.detail.isEmpty {
                    detailRow(label: "기타 안내", value: package.detail)
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 23)
        }
        .background(Color(.pWhite))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.pGrey3), lineWidth: 1)
        )
    }

    // MARK: - 커버 이미지

    private func coverImage(url: String?) -> some View {
        Group {
            if let imageURL = url,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        imagePlaceholder
                    }
                }
            } else {
                imagePlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(Color(.pGrey2))
            .overlay {
                Image(.profileImagePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
    }

    // MARK: - 상세 정보 행

    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .typo(.pBoldParagraph)
                .foregroundStyle(.pGrey4)
                .fixedSize()

            Text(value)
                .typo(.pParagraph)
                .foregroundStyle(.pGrey5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview("빈 상태") {
    PackageEditView(
        store: Store(
            initialState: PackageEditFeature.State()
        ) {
            PackageEditFeature()
        }
    )
}

#Preview("패키지 있음") {
    PackageEditView(
        store: Store(
            initialState: PackageEditFeature.State(
                packages: [
                    MyPageFeature.ShootingPackage(
                        id: "1",
                        title: "남친 생기는 프사♥",
                        price: 9900,
                        coverImageURL: nil,
                        shootingDuration: "15분 이내",
                        detail: "DSLR로 머어 찍어드립니다."
                    ),
                    MyPageFeature.ShootingPackage(
                        id: "2",
                        title: "⭐가성비 아이폰 웨딩스냅!!",
                        price: 12900,
                        coverImageURL: nil,
                        shootingDuration: "15분 이내",
                        detail: "DSLR로 머어 찍어드립니다."
                    )
                ]
            )
        ) {
            PackageEditFeature()
        }
    )
}
