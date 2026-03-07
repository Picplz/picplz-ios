//
//  FlowLayout.swift
//  Features
//
//  Created by 임영택 on 3/7/26.
//

import SwiftUI

/// 가변 폭의 객체를 왼쪽에서 오른쪽으로, 위에서 아래로 배치하는 레이아웃
struct FlowLayout: Layout {
  var spacing: CGFloat = 8

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    let containerWidth = proposal.replacingUnspecifiedDimensions().width
    let sizes = subviews.map { $0.sizeThatFits(.unspecified) }

    var totalHeight: CGFloat = 0
    var currentRowWidth: CGFloat = 0
    var currentRowHeight: CGFloat = 0

    for size in sizes {
      if currentRowWidth + size.width + spacing > containerWidth {
        // 줄바꿈 발생
        totalHeight += currentRowHeight + spacing
        currentRowWidth = size.width
        currentRowHeight = size.height
      } else {
        // 옆으로 쌓기
        currentRowWidth += size.width + spacing
        currentRowHeight = max(currentRowHeight, size.height)
      }
    }

    return CGSize(width: containerWidth, height: totalHeight + currentRowHeight)
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    var x = bounds.minX
    var y = bounds.minY
    var currentRowHeight: CGFloat = 0

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)

      if x + size.width > bounds.maxX {
        // 줄바꿈
        x = bounds.minX
        y += currentRowHeight + spacing
        currentRowHeight = 0
      }

      subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)

      x += size.width + spacing
      currentRowHeight = max(currentRowHeight, size.height)
    }
  }
}

struct TagContentView: View {
    let tags = ["SwiftUI", "UIKit", "Combine", "Swift", "iOS Development", "Xcode", "FlowLayout", "Mobile", "Apple", "App Store"]

    var body: some View {
        ScrollView {
            FlowLayout(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
    }
}

#Preview {
 TagContentView()
}
