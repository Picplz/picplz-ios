//
//  PackageAddView.swift
//  Features
//
//  Created by wonsik on 4/21/26.
//

import SwiftUI
import ComposableArchitecture

struct PackageAddView: View {
    @Bindable var store: StoreOf<PackageAddFeature>

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "촬영 패키지 편집") {
                store.send(.backButtonTapped)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    packageNameSection
                    bannerImageSection
                    shootingDurationSection
                    detailSection
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollDismissesKeyboard(.interactively)

            saveButton
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }

    // MARK: - 상품명

    private var packageNameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            requiredLabel("상품명")

            TextField("상품명을 입력해주세요. (최대 15자)", text: $store.packageName)
                .typo(.pParagraph)
                .padding(.vertical, 11)
                .padding(.horizontal, 15)
                .background(Color(.pGrey1))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.pGrey2), lineWidth: 1)
                )
        }
    }

    // MARK: - 배너 이미지 등록

    private var bannerImageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("배너 이미지 등록")
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)

            Text("nnn*nnn px 사이즈로 등록 추천")
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)

            Button {
                store.send(.bannerImageTapped)
            } label: {
                VStack(spacing: 12) {
                    Text("상품을 추가하세요")
                        .typo(.pButtonNormalLabel)
                        .foregroundStyle(.pGrey4)

                    Image(systemName: "plus")
                        .font(.system(size: 48, weight: .light))
                        .foregroundStyle(.pGrey3)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 166)
                .background(Color(.pGrey1))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .buttonStyle(.plain)
        }
        . padding(.vertical, 20)
    }

    // MARK: - 촬영 시간

    private var shootingDurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            requiredLabel("촬영 시간")

            let formatter: NumberFormatter = {
                let f = NumberFormatter()
                f.numberStyle = .decimal
                return f
            }()

            VStack(spacing: 0) {
                ForEach(PackageAddFeature.ShootingDuration.allCases, id: \.self) { duration in
                    let isSelected = store.selectedDuration == duration
                    let priceText = (formatter.string(from: NSNumber(value: duration.price)) ?? "\(duration.price)") + "원"

                    Button {
                        store.send(.durationSelected(duration))
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(isSelected ? Color(.pBlack) : .clear)
                                    .stroke(isSelected ? Color(.pBlack) : Color(.pGrey3), lineWidth: 1.5)
                                    .frame(width: 20, height: 20)

                                if isSelected {
                                    Circle()
                                        .fill(Color(.pWhite))
                                        .frame(width: 8, height: 8)
                                }
                            }

                            Text(duration.rawValue)
                                .typo(.pParagraph)
                                .foregroundStyle(isSelected ? .pBlack : .pGrey4)

                            Spacer()

                            Text(priceText)
                                .typo(.pParagraph)
                                .foregroundStyle(isSelected ? .pBlack : .pGrey4)
                        }
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 기타 안내사항

    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("기타 안내사항")
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.pGrey1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.pGrey2), lineWidth: 1)
                    )

                if store.detail.isEmpty {
                    Text("본인의 강점, 선호 촬영 방식 등 자유롭게 적어주세요.")
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey3)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $store.detail)
                    .typo(.pParagraph)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(store.detail.count)/\(PackageAddFeature.maxDetailLength)")
                            .typo(.pCaption)
                            .foregroundStyle(.pGrey3)
                            .padding(.bottom, 14)
                            .padding(.trailing, 16)
                    }
                }
            }
            .frame(height: 120)
        }
    }

    // MARK: - 저장 버튼

    private var saveButton: some View {
        Button {
            store.send(.saveButtonTapped)
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 50)
                .foregroundStyle(.pBlack)
                .overlay(
                    Text("저장")
                        .foregroundStyle(.pWhite)
                        .typo(.pButtonNormalLabel)
                )
        }
        .padding(.top, 20)
    }

    // MARK: - 필수 라벨

    private func requiredLabel(_ title: String) -> some View {
        HStack(spacing: 2) {
            Text(title)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
            Text("*")
                .typo(.pSmallTitle)
                .foregroundStyle(.pRed)
        }
    }
}

#Preview {
    PackageAddView(
        store: Store(
            initialState: PackageAddFeature.State()
        ) {
            PackageAddFeature()
        }
    )
}

#Preview("선택됨") {
    PackageAddView(
        store: Store(
            initialState: PackageAddFeature.State(
                packageName: "남친 생기는 프사♥",
                selectedDuration: .between15and30,
                detail: "DSLR로 찍어드립니다."
            )
        ) {
            PackageAddFeature()
        }
    )
}
