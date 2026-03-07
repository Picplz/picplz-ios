//
//  InputConceptsPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI

/// 뷰 구현을 위한 임시 분위기 엔티티
struct Concept: Identifiable {
  let id: Int
  var keyword: String
  var isSelected: Bool = false
  let isUserDefined: Bool

  mutating func editKeyword(to newKeyword: String) {
    if isUserDefined {
      keyword = newKeyword
    }
  }

  mutating func toggle() {
    isSelected.toggle()
  }
}

struct InputConceptsPage: View {
  @State private var concepts: [Concept] = [
    Concept(id: 0, keyword: "캐주얼", isUserDefined: false),
    Concept(id: 1, keyword: "고급미", isUserDefined: false),
    Concept(id: 2, keyword: "심플", isUserDefined: false),
    Concept(id: 3, keyword: "단아", isUserDefined: false),
    Concept(id: 4, keyword: "몽환적", isUserDefined: false),
    Concept(id: 5, keyword: "빈티지", isUserDefined: false),
    Concept(id: 6, keyword: "청량", isUserDefined: false),
    Concept(id: 7, keyword: "화려", isUserDefined: false),
    Concept(id: 8, keyword: "퇴폐적", isUserDefined: false),
    Concept(id: 9, keyword: "키치", isUserDefined: false),
    Concept(id: 10, keyword: "힙스터", isUserDefined: false),
  ]
  var nextConceptId: Int {
    concepts.last?.id ?? 0 + 1
  }

  // MARK: - Spacings
  let titletTopSpacing: CGFloat = 60
  let titleBottomSpacing: CGFloat = 20

  var body: some View {
    VStack(spacing: 0) {
      Text("자신 있는 분위기 키워드를 선택 해주세요.")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.top, titletTopSpacing)

      ScrollView(showsIndicators: false) {
        FlowLayout {
          ForEach(concepts.indices, id: \.self) { index in
            ConceptTag(concept: concepts[index]) {
              concepts[index].toggle()
            } didEdit: { newKeyword in
              concepts[index].editKeyword(to: newKeyword)
            }
          }

          NewConceptField { keyword in
            concepts.append(
              Concept(
                id: nextConceptId,
                keyword: keyword,
                isUserDefined: true
              )
            )
          }
        }
      }
      .padding(.top, titleBottomSpacing)

      Spacer()

      Button1(title: "다음") {
        // 위치 정보 확인
      }
    }
    .padding(.horizontal)
  }
}



#Preview {
  InputConceptsPage()
}
