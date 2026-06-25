//
//  LocationSearchView.swift
//  Features
//
//  Created by wonsik on 4/25/26.
//

import SwiftUI
import ComposableArchitecture
import Domain

struct LocationSearchView: View {
    @Bindable var store: StoreOf<LocationSearchFeature>
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.pGrey2))
                .frame(width: 40, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)

            VStack(alignment: .center, spacing: 16) {
                Text("촬영 장소를 선택해주세요")
                    .typo(.pTitle)
                    .foregroundStyle(.pBlack)

                searchBar

                resultsList
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .onAppear {
            isSearchFocused = true
        }
    }

    // MARK: - 검색창

    private var searchBar: some View {
        HStack(spacing: 8) {
            Text("|")
                .foregroundStyle(.pBlack)

            TextField("지역, 도로명, 건물명으로 검색", text: $store.query)
                .typo(.pParagraph)
                .focused($isSearchFocused)
        }
        .frame(height: 42)
        .padding(.horizontal, 16)
        .background(Color(.pGrey1))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(.pBlack), lineWidth: 1)
        )
    }

    // MARK: - 검색 결과 없음

    private var notFoundView: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 60)

            Text("검색 결과가 없어요")
                .font(.pretendard(weight: .semibold, size: 18))
                .foregroundStyle(.pGrey6)

            Image(.notfound)
                .padding(.top, 10)
                .padding(.bottom, 30)

            Text("다른 지역으로\n이동해 보는 건 어때요?")
                .font(.pretendard(weight: .regular, size: 14))
                .multilineTextAlignment(.center)
                .foregroundStyle(.pGrey5)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 검색 결과

    private var resultsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(store.results, id: \.id) { area in
                    Button {
                        store.send(.locationSelected(area))
                    } label: {
                        HStack(alignment: .top, spacing: 8) {
                            Image(.anchor)
                                .padding(.top, 4)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(area.name)
                                    .typo(.pBigParagraph)
                                    .foregroundStyle(.pBlack)

                                if let dong = area.dong {
                                    Text(dong)
                                        .typo(.pCaption)
                                        .foregroundStyle(.pGrey4)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)

                    if area.id != store.results.last?.id {
                        Rectangle()
                            .fill(Color(.pGrey2))
                            .frame(height: 1)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview("검색 결과") {
    LocationSearchView(
        store: Store(
            initialState: LocationSearchFeature.State(
                query: "마포",
                results: [
                    Area(id: 1, name: "서울 마포구 합정동", dong: "합정동", ri: nil),
                    Area(id: 2, name: "서울 마포구 서교동", dong: "서교동", ri: nil),
                    Area(id: 3, name: "서울 마포구 망원동", dong: "망원동", ri: nil),
                    Area(id: 4, name: "서울 마포구 연남동", dong: "연남동", ri: nil),
                    Area(id: 5, name: "서울 마포구 상수동", dong: "상수동", ri: nil),
                ]
            )
        ) {
            LocationSearchFeature()
        }
    )
}

#Preview("검색 결과 없음") {
    LocationSearchView(
        store: Store(
            initialState: LocationSearchFeature.State(
                query: "가좌 2로"
            )
        ) {
            LocationSearchFeature()
        }
    )
}

#Preview("초기 상태") {
    LocationSearchView(
        store: Store(
            initialState: LocationSearchFeature.State()
        ) {
            LocationSearchFeature()
        }
    )
}
