//
//  ConceptTag.swift
//  Features
//
//  Created by 임영택 on 3/7/26.
//

import SwiftUI

extension InputConceptsPage {
  struct ConceptTag: View {
    @State private var editingKeyword: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var focusState: Bool

    var concept: Concept
    let didSelect: () -> Void
    let didEdit: (_ newKeyword: String) -> Void

    var tagFont: Font {
      concept.isSelected
        ? .pretendard(weight: .semibold, size: 14)
        : .pretendard(weight: .regular, size: 14)
    }
    var textColor: Color {
      concept.isSelected ? .pBlack : .pGrey4
    }
    var borderColor: Color {
      concept.isSelected ? .pBlack : .pGrey3
    }
    var fillColor: Color {
      .pWhite
    }

    var body: some View {
      Group {
        if !isEditing {
          Button(action: didSelect) {
            HStack(spacing: 10) {
              Text(concept.keyword)

              if concept.isUserDefined {
                Image(.pencil)
                  .onTapGesture {
                    editingKeyword = concept.keyword
                    isEditing.toggle()
                    focusState.toggle()
                  }
              }
            }
          }
        } else {
          TextField("기존 키워드 수정", text: $editingKeyword)
            .focused($focusState)
            .onSubmit {
              didEdit(editingKeyword)
              editingKeyword = ""
              isEditing = false
              focusState.toggle()
            }
        }
      }
      .font(tagFont)
      .foregroundColor(textColor)
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
      .frame(height: 40, alignment: .center)
      .background(fillColor)
      .cornerRadius(5)
      .overlay(
        RoundedRectangle(cornerRadius: 5)
          .inset(by: 0.5)
          .stroke(borderColor)
      )
    }
  }

  struct NewConceptField: View {
    @State private var inputKeyword = ""
    let didSubmit: (_ keyword: String) -> Void

    let tagFont: Font = .pretendard(weight: .regular, size: 14)
    var textColor: Color {
      inputKeyword.isEmpty ? .pGrey3 : .pBlack
    }
    var borderColor: Color {
      inputKeyword.isEmpty ? .pGrey3 : .pBlack
    }
    let fillColor: Color = .pGrey1

    var body: some View {
      TextField(
        "새 키워드 이름",
        text: $inputKeyword,
        prompt: Text("+ 직접 적어주세요")
          .font(tagFont)
          .foregroundColor(textColor)
      )
      .onSubmit {
        didSubmit(inputKeyword)
        inputKeyword = ""
      }
      .font(tagFont)
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
      .frame(height: 40, alignment: .center)
      .background(fillColor)
      .cornerRadius(5)
      .overlay(
        RoundedRectangle(cornerRadius: 5)
          .inset(by: 0.5)
          .stroke(borderColor)
      )
    }
  }
}

#Preview {
  InputConceptsPage.ConceptTag(
    concept: Concept(id: 0, keyword: "캐주얼", isUserDefined: false)
  ) { } didEdit: { _ in }
  InputConceptsPage.ConceptTag(
    concept: Concept(
      id: 0,
      keyword: "고급미",
      isSelected: true,
      isUserDefined: false
    )
  ) { } didEdit: { _ in }
  InputConceptsPage.ConceptTag(
    concept: Concept(id: 2, keyword: "공주 감성", isUserDefined: true)
  ) { } didEdit: { _ in }
}
