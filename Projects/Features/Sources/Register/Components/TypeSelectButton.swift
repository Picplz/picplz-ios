//
//  TypeSelectButton.swift
//  Features
//
//  Created by 임영택 on 3/2/26.
//

import SwiftUI
import Domain

struct TypeSelectButton: View {
  let role: Role
  @Binding var selectedRole: Role?

  @State private var imageSize: CGFloat = Self.inactiveSize
  @State private var currentImage: ImageResource?
  @State private var currentLabelColor: Color = Self.inactiveColor

  let labelTopSpacing: CGFloat = 10

  private var isActive: Bool { selectedRole == role }

  init(role: Role, selectedRole: Binding<Role?>) {
    self.role = role
    self._selectedRole = selectedRole
    _currentImage = State(initialValue: role.inactiveIconImage)
  }

  var body: some View {
    VStack(spacing: labelTopSpacing) {
      VStack(spacing: 0) {
        Spacer()
        if let res = currentImage {
          Image(res)
            .resizable()
            .frame(width: imageSize, height: imageSize)
        }
      }
      .frame(width: imageSize, height: Self.activeSize, alignment: .bottom)
      
      Text(role.displayLabel)
        .typo(.pButtonNormalLabel)
        .foregroundStyle(currentLabelColor)
    }
    .onChange(of: selectedRole) { applyPhase() }
    .onTapGesture {
      handleTap()
    }
  }

  private func handleTap() {
    if !isActive {
      selectedRole = role
    } else {
      selectedRole = nil
    }
  }

  private func applyPhase() {
    if isActive {
      currentImage = role.activeIconImage
      currentLabelColor = Self.activeColor
      withAnimation(.easeInOut(duration: 0.2)) {
        imageSize = Self.activeSize
      }
    } else {
      withAnimation(.easeInOut(duration: 0.2)) {
        imageSize = Self.inactiveSize
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        currentImage = role.inactiveIconImage
        currentLabelColor = Self.inactiveColor
      }
    }
  }

  static let inactiveSize: CGFloat = 120
  static let inactiveColor: Color = .pGrey3
  static let activeSize: CGFloat = 160
  static let activeColor: Color = .pBlack
}

#Preview("모델 선택 아이콘") {
  @Previewable @State var selectedRole: Role? = nil
  TypeSelectButton(role: .customer, selectedRole: $selectedRole)
  TypeSelectButton(role: .photographer, selectedRole: $selectedRole)
}
