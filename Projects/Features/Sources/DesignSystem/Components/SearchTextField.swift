//
//  SearchTextField.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import SwiftUI

// MARK: - Base Style
private struct SearchTextFieldBaseModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(.pWhite)
      .cornerRadius(50)
      .overlay(
        RoundedRectangle(cornerRadius: 50)
          .inset(by: 0.5)
          .stroke(.pGrey6, lineWidth: 1)
      )
  }
}

// MARK: - Concrete Modifiers
private struct SimpleSearchModifier: ViewModifier {
  let submitButtonTapped: () -> Void
  
  func body(content: Content) -> some View {
    HStack(spacing: 0) {
      content
        .typo(.pParagraph)

      Button(action: submitButtonTapped) {
        Image(.search)
          .padding(1)
      }
    }
    .modifier(SearchTextFieldBaseModifier())
  }
}

private struct AdvancedSearchModifier: ViewModifier {
  @Binding var text: String
  let submitButtonTapped: () -> Void
  
  func body(content: Content) -> some View {
    HStack(spacing: 8) {
      content
        .typo(.pParagraph)
      
      if !text.isEmpty {
        Button(action: { text = "" }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(.pGrey3)
        }
      }

      Button(action: submitButtonTapped) {
        Image(.search)
          .resizable()
          .frame(width: 20, height: 20)
      }
    }
    .modifier(SearchTextFieldBaseModifier())
  }
}

// MARK: - Facade Interface
extension View {
  /// 기본 검색 스타일 (기존 호환용)
  func pSearchTextField(submitButtonTapped: @escaping () -> Void) -> some View {
    modifier(SimpleSearchModifier(submitButtonTapped: submitButtonTapped))
  }
  
  /// 엑스 버튼이 포함된 고급 검색 스타일
  func pSearchTextFieldWithClear(
    text: Binding<String>,
    submitButtonTapped: @escaping () -> Void
  ) -> some View {
    modifier(AdvancedSearchModifier(text: text, submitButtonTapped: submitButtonTapped))
  }
}

#Preview {
  @Previewable @State var query = ""

  VStack(spacing: 20) {
    TextField(
      "기본 검색",
      text: $query,
      prompt: Text("기본 검색").foregroundStyle(.pGrey3)
    )
    .pSearchTextField {
      print("Simple: \(query)")
    }
    
    TextField(
      "고급 검색 (Clear)",
      text: $query,
      prompt: Text("고급 검색 (Clear)").foregroundStyle(.pGrey3)
    )
    .pSearchTextFieldWithClear(text: $query) {
      print("Advanced: \(query)")
    }
  }
  .padding()
}
