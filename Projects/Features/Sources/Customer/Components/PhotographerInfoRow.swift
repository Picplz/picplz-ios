//
//  PhotographerInfoRow.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct PhotographerInfoRow: View {
  let label: String
  let value: String
  var isExpandable: Bool = false
  var isExpanded: Bool = false
  var onExpand: (() -> Void)?
  
  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      Text(label)
        .typo(.pInsideTag)
        .foregroundStyle(.pBlack)
        .frame(width: 32, alignment: .leading)
      
      HStack(alignment: isExpanded ? .bottom : .center, spacing: 4) {
        Text(value)
          .typo(.pCaption)
          .foregroundStyle(.pGrey4)
          .lineLimit(isExpandable && !isExpanded ? 1 : nil)
        
        if isExpandable {
          Button(action: { onExpand?() }) {
            if isExpanded {
              Text("접기")
                .typo(.pInsideTag)
                .foregroundStyle(.pGreen120)
                .padding(.leading, 4)
            } else {
              Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundStyle(.pGrey4)
            }
          }
        }
      }
      
      Spacer()
    }
    .padding(.horizontal, 16)
  }
}

#Preview {
  VStack(spacing: 10) {
    PhotographerInfoRow(label: "촬영지", value: "마포구, 동작구, 머머구 외 5개", isExpandable: true)
    PhotographerInfoRow(label: "키워드", value: "#캐주얼, #고급미")
    PhotographerInfoRow(label: "장비", value: "아이폰 16 PRO, 아이폰X, 갤럭시23 울트라")
  }
}
