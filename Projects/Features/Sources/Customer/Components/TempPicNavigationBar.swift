//
//  TempPicNavigationBar.swift
//  Features
//
//  Created by 임영택 on 4/12/26.
//

import SwiftUI

/// 임시 네비게이션바 - 나중에 통합 네비게이션으로 교체 예정
public struct TempPicNavigationBar: View {
  let title: String
  let onBack: () -> Void
  let rightContent: AnyView?
  
  public init(
    title: String,
    onBack: @escaping () -> Void,
    @ViewBuilder rightContent: () -> some View = { EmptyView() }
  ) {
    self.title = title
    self.onBack = onBack
    let content = rightContent()
    if content is EmptyView {
      self.rightContent = nil
    } else {
      self.rightContent = AnyView(content)
    }
  }
  
  public var body: some View {
    ZStack {
      HStack(spacing: 0) {
        Button(action: onBack) {
          Image(systemName: "chevron.left")
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.pBlack)
            .frame(width: 44, height: 44)
        }
        
        Spacer()
        
        if let rightContent {
          rightContent
            .frame(minWidth: 44, minHeight: 44)
        } else {
          Spacer().frame(width: 44)
        }
      }
      
      Text(title)
        .typo(.pSmallTitle)
        .foregroundStyle(.pBlack)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 44)
    .background(.pWhite)
  }
}

#Preview {
  VStack {
    TempPicNavigationBar(title: "리뷰", onBack: {})
    TempPicNavigationBar(title: "제목", onBack: {}) {
      Button(action: {}) {
        Image(systemName: "ellipsis")
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(.pBlack)
      }
    }
    Spacer()
  }
}
