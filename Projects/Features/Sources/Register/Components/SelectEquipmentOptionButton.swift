//
//  SelectEquipmentOptionButton.swift
//  Features
//
//  Created by 임영택 on 3/7/26.
//
import SwiftUI

struct SelectEquipmentOptionButton: View {
  @State private var isSheetShowing: Bool = false
  @State private var manualInputText: String = ""
  @State private var sheetContentHeight: CGFloat = 300
  @FocusState private var focusToManualInput: Bool

  let placeholder: String
  let options: [String]
  @Binding var selectedOption: String?

  var isAllowManualInput: Bool = false

  var buttonTitle: String {
    selectedOption ?? placeholder
  }
  let backgroundColor = Color.pWhite
  var labelColor: Color {
    selectedOption == nil ? .pGrey5 : .pBlack
  }
  var borderColor: Color {
    selectedOption == nil ? .pGrey3 : .pBlack
  }
  let height = CGFloat(42)

  var body: some View {
    Button {
      isSheetShowing.toggle()
    } label: {
      RoundedRectangle(cornerRadius: 5, style: .circular)
        .fill(backgroundColor)
        .stroke(borderColor, lineWidth: 1)
        .frame(height: height)
        .overlay {
          Text(buttonTitle)
            .typo(.pParagraph)
            .foregroundStyle(labelColor)
        }
    }
    .sheet(isPresented: $isSheetShowing) {
      ScrollView {
        VStack(spacing: 0) {
          if isAllowManualInput {
            TextField(
              "직접 입력",
              text: $manualInputText,
              prompt: Text("직접 입력하기").foregroundStyle(.pGrey3)
            )
            .pTextField(isFocused: focusToManualInput)
            .focused($focusToManualInput)
            .onSubmit(onManualOptionSubmit)
            .toolbar {
              ToolbarItemGroup(placement: .keyboard) {
                Button("완료") {
                  resignKeyboard()
                }
              }
            }
            .padding(.vertical)
          }

          ForEach(options.indices, id: \.self) { index in
            Button {
              selectedOption = options[index]
            } label: {
              Text(options[index])
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            if index != options.count - 1 {
              Rectangle()
                .fill(.pGrey2)
                .frame(height: 1)
            }
          }
        }
        .padding()
        .background(
          GeometryReader { geo in
            Color.clear.onAppear {
              sheetContentHeight = geo.size.height
            }
          }
        )
      }
      .background(Color.pWhite.edgesIgnoringSafeArea(.all))
      .presentationDetents([.height(sheetContentHeight)])
      .presentationDragIndicator(.visible)
    }
    .onChange(of: selectedOption) { _, newValue in
      isSheetShowing = false
    }
    .onChange(of: isSheetShowing) { _, newValue in
      if !newValue && !manualInputText.isEmpty {
        onManualOptionSubmit()
      }
    }
  }
}

extension SelectEquipmentOptionButton {
  func allowManualInput(_ allow: Bool = true) -> Self {
    var copy = self
    copy.isAllowManualInput = allow
    return copy
  }
}

extension SelectEquipmentOptionButton {
  private func onManualOptionSubmit() {
    let trimmed = manualInputText.trimmingCharacters(
      in: .whitespacesAndNewlines
    )
    if !trimmed.isEmpty {
      selectedOption = trimmed
    }

    manualInputText = ""
    focusToManualInput = false
  }
}

#Preview {
  @Previewable @State var selected: String? = nil

  SelectEquipmentOptionButton(
    placeholder: "추가하기 +",
    options: [
      "안녕", "하세요", "세계",
    ],
    selectedOption: $selected
  )
  .allowManualInput(true)
  .padding()
}
