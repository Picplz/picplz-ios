//
//  PastShootingsView.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI
import ComposableArchitecture

struct PastShootingsView: View {
    let store: StoreOf<PastShootingsFeature>

    var body: some View {
        VStack {
            SubNavigationBar(title: "지난 촬영 내역") {
                store.send(.backButtonTapped)
            }

            if store.pastShootings.isEmpty {
                EmptyStateView(
                    title: "아직 촬영 내역이 없어요",
                    description: "촬영을 진행해 보세요"
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(store.pastShootings) { shooting in
                            PastShootingCardView(
                                shooting: shooting,
                                onChatTapped: {
                                    store.send(.chatButtonTapped(shooting.id))
                                },
                                onReviewTapped: {
                                    store.send(.reviewButtonTapped(shooting.id))
                                },
                                onOrderDetailTapped: {
                                    store.send(.orderDetailTapped(shooting.id))
                                }
                            )
                        }
                    }
                    .padding(.top, 16)
                }
            }
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}

#Preview("List") {
    PastShootingsView(
        store: Store(
            initialState: {
                var state = PastShootingsFeature.State()
                state.pastShootings = [
                    .init(
                        id: "1",
                        photographerName: "합정동작가",
                        photographerImageURL: nil,
                        title: "남친생기는 프사",
                        price: 12000,
                        status: .cancelled,
                        dateTime: "25.03.24 | 오후2:30",
                        location: "종로구 효자로 33 어디어디 어디어디 어디 어디 어디어디빌딩 뭐뭐",
                        paymentDate: "2025.03.01"
                    ),
                    .init(
                        id: "2",
                        photographerName: "유가영사진",
                        photographerImageURL: nil,
                        title: "인스타 피드꾸미기",
                        price: 12000,
                        status: .completed,
                        dateTime: "25.03.24 | 오후2:30",
                        location: "종로구 효자로 33 어디어디 어디",
                        paymentDate: "2025.03.01"
                    ),
                ]
                return state
            }()
        ) {
            PastShootingsFeature()
        }
    )
}

#Preview("Empty") {
    PastShootingsView(
        store: Store(
            initialState: PastShootingsFeature.State()
        ) {
            PastShootingsFeature()
        }
    )
}
