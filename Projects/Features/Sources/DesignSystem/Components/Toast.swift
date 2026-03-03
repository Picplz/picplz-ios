//
//  Toast.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI

struct ToastModifier: ViewModifier {
  @Binding var item: ToastItem?
  let seconds: Double = 2.0

  func body(content: Content) -> some View {
    ZStack {
      content

      if let toast = item {
        VStack {
          Spacer()
          Text(toast.message)
            .typo(.pParagraph)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Self.backgroundColor)
            .cornerRadius(50)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 86)
        .zIndex(1)
        .task(id: toast.id) {
          try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
          withAnimation {
            item = nil
          }
        }
      }
    }
    .animation(.spring(), value: item)
  }
  
  private static let backgroundColor = Color(red: 0x0E / 255, green: 0x0E / 255, blue: 0x0F / 255, opacity: 0.6)
}

extension View {
  func toast(item: Binding<ToastItem?>) -> some View {
    self.modifier(ToastModifier(item: item))
  }
}

struct ToastItem: Equatable {
  let id = UUID()
  let message: String
}

#Preview {
  @Previewable @State var toastItem: ToastItem? = nil

  VStack {
    Button("토스트 보이기") {
      toastItem = ToastItem(message: "안녕 세계")
    }
  }
  .toast(item: $toastItem)
}
