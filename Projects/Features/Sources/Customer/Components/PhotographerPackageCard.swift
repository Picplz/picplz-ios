//
//  PhotographerPackageCard.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct PhotographerPackageCard: View {
  let title: String
  let price: String
  let time: String
  let info: String
  let imageData: Data?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Package Image
      if let data = imageData, let uiImage = UIImage(data: data) {
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
        Text(title)
          .typo(.pTitle)
          .foregroundStyle(.pBlack)
        
        Text(price)
          .typo(.pSmallTitle)
          .foregroundStyle(.pGrey6)
      }
      
      // Details
      VStack(alignment: .leading, spacing: 4) {
        detailRow(label: "촬영 시간", value: time)
        detailRow(label: "기타 안내", value: info)
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
  PhotographerPackageCard(
    title: "남친 생기는 프사❤️",
    price: "9,900원",
    time: "15분 이내",
    info: "여자친구 /남자친구 생기는 카톡프사 찍어드립니당~ 요즘 인스타그램 감성으로 이쁘게! 베스트컷 5개정도 같이 뽑아드려용!",
    imageData: nil
  )
}
