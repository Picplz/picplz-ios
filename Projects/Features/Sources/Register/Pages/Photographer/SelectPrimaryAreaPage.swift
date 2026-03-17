//
//  SelectPrimaryAreaPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import ComposableArchitecture
import Domain
import PhotosUI
import SwiftUI

struct SelectPrimaryAreaPage: View {
  @Bindable var store: StoreOf<SelectPrimaryAreaFeature>

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 16
  let titleBottomSpacing: CGFloat = 30
  var textFieldBottomSpacing: CGFloat {
    store.searchQuery.isEmpty ? 20 : 30
  }
  let notfoundTopSpacing: CGFloat = 101
  let tagsBottomSpacing: CGFloat = 20

  var body: some View {
    VStack(spacing: 0) {
      Text("주 촬영지를 선택해 주세요.")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.top, titleTopSpacing)
        .padding(.bottom, titleBottomSpacing)

      TextField(
        "주 촬영지 검색",
        text: $store.searchQuery.sending(\.searchQueryChanged),
        prompt: Text("구 단위로 검색 (ex, 마포구)").foregroundStyle(.pGrey3)
      )
      .pSearchTextField {}
      .padding(.bottom, textFieldBottomSpacing)

      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .center, spacing: 4) {
          Image(.anchor)
          Text(store.searchResultTitle)
            .typo(.pButtonNormalLabel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Spacer()
          .frame(height: 8)

        if store.isShowNotFound {
          VStack(spacing: 0) {
            Text("검색 결과가 없어요")
              .font(.pretendard(weight: .semibold, size: 18))
              .foregroundColor(.pGrey6)
              .frame(maxWidth: .infinity)

            Image(.notfound)
              .padding(.top, 10)
              .padding(.bottom, 30)

            Text("다른 지역으로\n이동해 보는 건 어때요?")
              .font(.pretendard(weight: .regular, size: 14))
              .multilineTextAlignment(.center)
              .foregroundColor(.pGrey5)
              .frame(maxWidth: .infinity)
          }
          .padding(.top, notfoundTopSpacing)
        } else {
          ScrollView(content: {
            VStack(spacing: 0) {
              ForEach(store.areas, id: \.id) { area in
                let isLast = area == store.areas.last
                LocationCell(
                  title: area.name,
                  isSelected: store.selectedAreas.contains(area),
                  isLast: isLast
                ) {
                  store.send(.areaTapped(area))
                }
              }
            }
          })
          .frame(maxWidth: .infinity)
        }
      }
      .padding(0)
      .frame(maxWidth: .infinity)

      Spacer()

      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(store.selectedAreas, id: \.id) { area in
              AreaTagButton(
                areaName: area.name
              ) {
                // 선택 지역 태그 클릭 시 로직 없음
              } didDeleteTap: {
                store.send(.deleteAreaTapped(area))
              }
              .id(area.id)
            }

            Spacer()
          }
        }
        .onChange(of: store.selectedAreas) { _, newValue in
          guard let lastItem = newValue.last else { return }
          withAnimation(.easeInOut) {
            proxy.scrollTo(lastItem.id, anchor: .trailing)
          }
        }
      }
      .padding(.bottom, tagsBottomSpacing)

      Button1(title: "다음") {
        store.send(.nextButtonTapped)
      }
      .disabled(store.selectedAreas.isEmpty)
    }
    .padding(.horizontal)
    .toast(item: $store.toastItem.sending(\.toastItemChanged))
    .onAppear {
      store.send(.onAppear)
    }
    .navigationTitle("주 촬영지 선택")
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension SelectPrimaryAreaPage {
  struct LocationCell: View {
    let title: String
    let isSelected: Bool
    let isLast: Bool
    let tapAction: () -> Void

    var typo: TypographyStyle {
      isSelected ? .pBoldParagraph : .pParagraph
    }
    var textColor: Color {
      isSelected ? .pBlack : .pGrey5
    }

    var body: some View {
      VStack(alignment: .trailing, spacing: 0) {
        Button(action: tapAction) {
          Text(title)
            .typo(typo)
            .foregroundColor(textColor)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        if !isLast {
          Rectangle()
            .fill(Color.pGrey2)
            .frame(height: 1)
        }
      }
    }
  }
}

#Preview {
  SelectPrimaryAreaPage(
    store: Store(
      initialState: SelectPrimaryAreaFeature.State(),
      reducer: {
        SelectPrimaryAreaFeature()
      },
      withDependencies: {
        $0.getNearDongsUseCase = GetNearDongsUseCase(execute: {
          [
            Area(id: 1, name: "서울 서대문구 신촌동", dong: "신촌동", ri: ""),
            Area(id: 2, name: "서울 마포구 서교동", dong: "서교동", ri: ""),
            Area(id: 3, name: "서울 강남구 역삼동", dong: "역삼동", ri: "")
          ]
        })
      }
    )
  )
}
