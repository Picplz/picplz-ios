//
//  Typography.swift
//  Presentation
//
//  Created by 임영택 on 1/19/26.
//

import Foundation
import SwiftUI

// MARK: - Tuist가 생성한 폰트 관련 코드와 매핑

extension Font {
  static func pretendard(weight: PretendardWeight, size: CGFloat) -> Font {
    weight.tuistPresentationFont.swiftUIFont(size: size)
  }
}

extension UIFont {
  static func pretendard(weight: PretendardWeight, size: CGFloat) -> UIFont {
    weight.tuistPresentationFont.font(size: size)
  }
}

enum PretendardWeight {
  case regular
  case semibold
  case bold
  
  var tuistPresentationFont: PresentationFontConvertible {
    switch self {
    case .regular:
      return PresentationFontFamily.Pretendard.regular
    case .semibold:
      return PresentationFontFamily.Pretendard.semiBold
    case .bold:
      return PresentationFontFamily.Pretendard.bold
    }
  }
}

// MARK: - 폰트 시스템 정의

enum TypographyStyle: String, CaseIterable {
  case pBigTitle
  case pTitle
  case pSmallTitle
  case pBigParagraph
  case pBoldParagraph
  case pParagraph
  case pCaption
  case pInsideTag
  case pBigParagraph2
  case pButtonNormalLabel
  case pButtonChatLabel
  
  var swiftUIFont: Font {
    switch self {
    case .pBigTitle:
        return .pretendard(weight: .bold, size: 24)
    case .pTitle:
        return .pretendard(weight: .bold, size: 20)
    case .pSmallTitle:
        return .pretendard(weight: .semibold, size: 18)
    case .pBigParagraph:
        return .pretendard(weight: .regular, size: 16)
    case .pBigParagraph2:
        return .pretendard(weight: .semibold, size: 16)
    case .pBoldParagraph:
        return .pretendard(weight: .semibold, size: 14)
    case .pParagraph:
        return .pretendard(weight: .regular, size: 14)
    case .pCaption:
        return .pretendard(weight: .regular, size: 12)
    case .pInsideTag:
        return .pretendard(weight: .semibold, size: 12)
    case .pButtonNormalLabel:
        return .pretendard(weight: .bold, size: 16)
    case .pButtonChatLabel:
        return .pretendard(weight: .bold, size: 12)
    }
  }
  
  var uiFont: UIFont {
    switch self {
    case .pBigTitle:
        return .pretendard(weight: .bold, size: 24)
    case .pTitle:
        return .pretendard(weight: .bold, size: 20)
    case .pSmallTitle:
        return .pretendard(weight: .semibold, size: 18)
    case .pBigParagraph:
        return .pretendard(weight: .regular, size: 16)
    case .pBigParagraph2:
        return .pretendard(weight: .semibold, size: 16)
    case .pBoldParagraph:
        return .pretendard(weight: .semibold, size: 14)
    case .pParagraph:
        return .pretendard(weight: .regular, size: 14)
    case .pCaption:
        return .pretendard(weight: .regular, size: 12)
    case .pInsideTag:
        return .pretendard(weight: .semibold, size: 12)
    case .pButtonNormalLabel:
        return .pretendard(weight: .bold, size: 16)
    case .pButtonChatLabel:
        return .pretendard(weight: .bold, size: 12)
    }
  }
  
  var lineHeightMultiplier: CGFloat {
    1.4
  }
  
  var targetLineHeight: CGFloat {
      return uiFont.pointSize * lineHeightMultiplier
  }

  var letterSpacing: CGFloat {
    0
  }
}

// MARK: - SwiftUI 헬퍼 정의

/// ref: https://stackoverflow.com/a/64652348
struct TypographyModifier: ViewModifier {
  let style: TypographyStyle
  
  var lineSpacing: CGFloat {
    style.targetLineHeight - style.uiFont.lineHeight
  }
  
  var verticalPadding: CGFloat {
    lineSpacing / 2
  }

  func body(content: Content) -> some View {
    content
      .font(Font(style.uiFont))
      .kerning(style.letterSpacing)
      .lineSpacing(lineSpacing)
      .padding(.vertical, verticalPadding)
  }
}

extension View {
  func typo(_ style: TypographyStyle) -> some View {
    self.modifier(TypographyModifier(style: style))
  }
}

// MARK: - Preview

#Preview {
  struct TypographyDemoPreviewContainer: View {
    @ViewBuilder func demoTypoView(style: TypographyStyle) -> some View {
      Text("스타일 - \(style.rawValue)")
        .typo(style)
        .border(.gray, width: 0.5)

      Text("당신의 사진이 만족스럽지 않다면, 충분히 다가가지 않은 것이다. - 로버트 카파")
        .typo(style)
        .border(.gray, width: 0.5)

      Text("If your pictures aren't good enough, you're not close enough. - Robert Capa")
        .typo(style)
        .border(.gray, width: 0.5)

      Divider()
    }

    var body: some View {
      ScrollView {
        VStack(spacing: 12) {
          ForEach(TypographyStyle.allCases, id: \.self) { style in
            demoTypoView(style: style)
          }
        }
        .padding()
      }
    }
  }

  return TypographyDemoPreviewContainer()
}
