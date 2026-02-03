//
//  LoginButton.swift
//  Features
//
//  Created by 임영택 on 2/3/26.
//

import SwiftUI

struct LoginButton: View {
  let didTap: () -> Void

  private var provider: Provider = .kakao
  private let cornerRadius: CGFloat = 5

  init(didTap: @escaping () -> Void) {
    self.didTap = didTap
  }

  var body: some View {
    Button(action: didTap) {
      RoundedRectangle(cornerRadius: cornerRadius)
        .foregroundStyle(provider.backgroundColor)
        .frame(height: 60)
        .overlay(
          ZStack {
            HStack(spacing: 0) {
              Spacer().frame(width: 30)
              Image(provider.image)
                .renderingMode(.template)
                .foregroundStyle(provider.titleColor)
              Spacer()
            }

            Text(provider.title)
              .foregroundStyle(provider.titleColor)
              .frame(maxWidth: .infinity)
              .multilineTextAlignment(.center)
              .typo(.pButtonNormalLabel)
          }
        )
    }
  }
}

extension LoginButton {
  func provider(_ provider: Provider) -> LoginButton {
    var copy = self
    copy.provider = provider
    return copy
  }
}

extension LoginButton {
  enum Provider {
    case kakao
    case apple

    var backgroundColor: Color {
      switch self {
      case .kakao:
        return Color(red: 0xF7 / 255, green: 0xE4 / 255, blue: 0x36 / 255)
      case .apple: return .pBlack
      }
    }

    var image: ImageResource {
      switch self {
      case .kakao: return .kakaoSignIn
      case .apple: return .appleSignIn
      }
    }

    var title: String {
      switch self {
      case .kakao: return "카카오로 계속하기"
      case .apple: return "애플로 계속하기"
      }
    }

    var titleColor: Color {
      switch self {
      case .kakao: return .pBlack
      case .apple: return .pWhite
      }
    }
  }
}

#Preview {
  VStack {
    LoginButton {}
      .provider(.kakao)

    LoginButton {}
      .provider(.apple)
  }
  .padding()
}
