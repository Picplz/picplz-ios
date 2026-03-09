//
//  SelectPrimaryAreaPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import Domain
import PhotosUI
import SwiftUI

struct SelectPrimaryAreaPage: View {
  @State private var searchQuery: String = ""
  @State private var searchResults: [String] = []
  @State private var selectedAreas: [String] = []
  @State private var toastItem: ToastItem? = nil
  var displayAreaList: [String] {
    if searchQuery.isEmpty {
      return testLocations
    } else {
      return testLocations.filter { $0.contains(searchQuery) }
    }
  }
  var isShowNotFound: Bool {
    !searchQuery.isEmpty && displayAreaList.isEmpty
  }
  var searchResultTitle: String {
    searchQuery.isEmpty ? "인근 지역" : "‘\(searchQuery)’ 검색 결과"
  }

  // MARK: - Spacings
  let titleTopSpacing: CGFloat = 16
  let titleBottomSpacing: CGFloat = 30
  var textFieldBottomSpacing: CGFloat {
    searchQuery.isEmpty ? 20 : 30
  }
  let notfoundTopSpacing: CGFloat = 101
  let tagsBottomSpacing: CGFloat = 20

  let attributedTitle: AttributedString = {
    var attributed = AttributedString("앱 서비스 이용을 위해\n위치 접근 권한이 필요해요")
    guard let range = attributed.range(of: "위치 접근 권한") else {
      return attributed
    }
    attributed[range].foregroundColor = .pGreen120
    return attributed
  }()

  var body: some View {
    VStack(spacing: 0) {
      Text("주 촬영지를 선택해 주세요.")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.top, titleTopSpacing)
        .padding(.bottom, titleBottomSpacing)

      TextField(
        "주 촬영지 검색",
        text: $searchQuery,
        prompt: Text("구 단위로 검색 (ex, 마포구)").foregroundStyle(.pGrey3)
      )
      .pSearchTextField {}
      .padding(.bottom, textFieldBottomSpacing)

      VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .center, spacing: 4) {
          Image(.anchor)
          Text(searchResultTitle)
            .typo(.pButtonNormalLabel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Spacer()
          .frame(height: 8)

        if isShowNotFound {
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
              ForEach(displayAreaList.indices, id: \.self) { index in
                LocationCell(
                  title: displayAreaList[index],
                  isSelected: selectedAreas.contains(displayAreaList[index]),
                  isLast: index == displayAreaList.count - 1
                ) {
                  handleSelectArea(displayAreaList[index])
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
            ForEach(selectedAreas, id: \.self) { area in
              AreaTagButton(
                areaName: area
              ) {
              } didDeleteTap: {
                if let index = selectedAreas.firstIndex(of: area) {
                  selectedAreas.remove(at: index)
                }
              }
              .id(area)
            }

            Spacer()
          }
        }
        .onChange(of: selectedAreas) { _, newValue in
          guard let lastItem = newValue.last else { return }
          withAnimation(.easeInOut) {
            proxy.scrollTo(lastItem, anchor: .trailing)
          }
        }
      }
      .padding(.bottom, tagsBottomSpacing)

      Button1(title: "다음") {
        //
      }
    }
    .padding(.horizontal)
    .toast(item: $toastItem)
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

extension SelectPrimaryAreaPage {
  private func handleSelectArea(_ area: String) {
    guard !selectedAreas.contains(area) else {
      toastItem = ToastItem(message: "이미 선택한 항목입니다.")
      return
    }

    guard selectedAreas.count < 5 else {
      toastItem = ToastItem(message: "활동 지역은 최대 5개까지 선택할 수 있습니다.")
      return
    }

    selectedAreas.append(area)
  }
}

extension SelectPrimaryAreaPage {
  // TODO: 서버 연동 후 제거
  var testLocations: [String] {
    ["서울 서대문구", "서울 마포구", "서울 강남구", "서울 종로구", "경기 김포시", "경기 안산시"]
  }
}

#Preview {
  SelectPrimaryAreaPage()
}
