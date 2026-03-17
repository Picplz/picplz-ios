//
//  InputConceptsPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import ComposableArchitecture
import SwiftUI

struct InputConceptsPage: View {
  @Bindable var store: StoreOf<InputConceptsFeature>

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
          ForEach(store.concepts.indices, id: \.self) { index in
            ConceptTag(concept: store.concepts[index]) {
              store.send(.conceptToggled(index))
            } didEdit: { newKeyword in
              store.send(.conceptKeywordEdited(index, newKeyword))
            }
          }

          NewConceptField { keyword in
            store.send(.addNewConcept(keyword))
          }
        }
      }
      .padding(.top, titleBottomSpacing)

      Spacer()

      Button1(title: "다음") {
        store.send(.nextButtonTapped)
      }
    }
    .padding(.horizontal)
    .navigationTitle("분위기 키워드 선택")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  InputConceptsPage(
    store: Store(initialState: InputConceptsFeature.State()) {
      InputConceptsFeature()
    }
  )
}
