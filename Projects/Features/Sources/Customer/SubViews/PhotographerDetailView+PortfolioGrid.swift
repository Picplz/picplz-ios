//
//  PhotographerDetailView+PortfolioGrid.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

extension PhotographerDetailView {
  struct PortfolioGrid: View {
    let imagesData: [Data]
    let onMore: () -> Void
    
    private let columns = [
      GridItem(.flexible(), spacing: 2),
      GridItem(.flexible(), spacing: 2),
      GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        Text("포트폴리오")
          .typo(.pSmallTitle)
          .foregroundStyle(.pBlack)
        
        if imagesData.isEmpty {
          emptyView
        } else {
          LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<min(imagesData.count, 9), id: \.self) { index in
              if let uiImage = UIImage(data: imagesData[index]) {
                Image(uiImage: uiImage)
                  .resizable()
                  .scaledToFill()
                  .frame(height: 113) // 고정 높이 (비율 유지)
                  .clipped()
              }
            }
          }
          
          Button(action: onMore) {
            HStack(spacing: 4) {
              Spacer()
              Text("포트폴리오 더보기")
                .typo(.pCaption)
                .foregroundStyle(.pGrey4)
              Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundStyle(.pGrey4)
            }
          }
        }
      }
      .padding(.top, 40)
      .padding(.horizontal, 16)
    }
    
    private var emptyView: some View {
      Rectangle()
        .fill(.pGrey2)
        .frame(width: 113, height: 113)
        .cornerRadius(5)
        .overlay(
          VStack(spacing: 4) {
            Text("아직")
            Text("포트폴리오가")
            Text("없어요")
          }
          .typo(.pBoldParagraph)
          .foregroundStyle(.pGrey3)
          .multilineTextAlignment(.center)
        )
    }
  }
}
