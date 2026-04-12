//
//  PhotographerPackageCard.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import Domain

struct PhotographerPackageCard: View {
  let package: PhotographerPackage
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Package Image
      if let data = package.imageData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .scaledToFill()
          .frame(height: 160)
          .cornerRadius(5)
          .clipped()
      } else {
        Rectangle()
          .fill(.pGrey2)
          .frame(height: 160)
          .cornerRadius(5)
          .overlay(
            Image(.packageNotFound) // 에셋 사용
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 100)
          )
      }
      
      // Title & Price
      VStack(alignment: .leading, spacing: 4) {
        Text(package.title)
          .typo(.pTitle)
          .foregroundStyle(.pBlack)
        
        Text(package.price)
          .typo(.pSmallTitle)
          .foregroundStyle(.pGrey6)
      }
      
      // Details
      VStack(alignment: .leading, spacing: 4) {
        detailRow(label: "촬영 시간", value: package.time)
        detailRow(label: "기타 안내", value: package.info)
      }
    }
    .padding(.horizontal, 16)
  }
  
  private func detailRow(label: String, value: String) -> some View {
    HStack(alignment: .top, spacing: 10) {
      Text(label)
        .typo(.pInsideTag)
        .foregroundStyle(.pGrey6)
      
      Text(value)
        .typo(.pCaption)
        .foregroundStyle(.pGrey4)
        .lineLimit(nil)
      
      Spacer()
    }
  }
}

#Preview {
  PhotographerPackageCard(package: .profile)
}
