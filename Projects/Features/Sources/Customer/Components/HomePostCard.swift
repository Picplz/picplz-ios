//
//  HomePostCard.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct HomePostCard: View {
  let authorName: String
  let authorLocation: String
  let postImagesData: [Data]
  let postLocation: String
  let postDate: String
  let onReportTapped: () -> Void
  
  @State private var currentPage = 0
  
  private var imageRatio: CGFloat {
    guard let firstData = postImagesData.first,
          let image = UIImage(data: firstData),
          image.size.height > 0 else {
      return 343/428 // 이미지가 없을 때의 기본 디자인 비율
    }
    return image.size.width / image.size.height
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Header
      HStack(spacing: 10) {
        Circle()
          .fill(.pGrey2)
          .frame(width: 30, height: 30)
          .overlay(
            Image(systemName: "person.fill")
              .font(.system(size: 15))
              .foregroundStyle(.pGrey3)
          )
        
        VStack(alignment: .leading, spacing: 0) {
          Text(authorName)
            .typo(.pBigParagraph2)
            .foregroundStyle(.pGrey5)
          
          Text(authorLocation)
            .typo(.pCaption)
            .foregroundStyle(.pGrey4)
        }
        
        Spacer()
        
        Button(action: onReportTapped) {
          Text("신고")
            .typo(.pCaption)
            .foregroundStyle(.pBlack)
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
            .background(.pGrey1)
            .cornerRadius(5)
        }
      }
      .padding(.vertical, 10)
      
      // Image Area
      ZStack(alignment: .bottom) {
        TabView(selection: $currentPage) {
          ForEach(0..<postImagesData.count, id: \.self) { index in
            if let uiImage = UIImage(data: postImagesData[index]) {
              Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .tag(index)
            } else {
              Color.pGrey1
                .tag(index)
            }
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .aspectRatio(imageRatio, contentMode: .fit)
        .cornerRadius(5)
        .clipped()
        
        // Page Indicator
        HStack(spacing: 4) {
          ForEach(0..<postImagesData.count, id: \.self) { index in
            Circle()
              .fill(currentPage == index ? .pBlack : .pGrey3)
              .frame(width: 6, height: 6)
          }
        }
        .padding(.bottom, 10)
        
        // Page Count
        VStack {
          HStack {
            Spacer()
            Text("\(currentPage + 1)/\(postImagesData.count)")
              .typo(.pParagraph)
              .foregroundStyle(.pGrey2)
              .padding(.horizontal, 7)
              .padding(.vertical, 2)
              .background(.pBlack.opacity(0.6))
              .cornerRadius(5)
          }
          Spacer()
        }
        .padding(12)
      }
      
      // Footer
      HStack(spacing: 3) {
        Image(systemName: "mappin.circle.fill")
          .font(.system(size: 12))
          .foregroundStyle(.pGrey3)
        
        Text("\(postLocation)  ｜  \(postDate)")
          .typo(.pCaption)
          .foregroundStyle(.pGrey3)
      }
      .padding(.top, 22)
      .padding(.bottom, 10)
      
      Divider()
        .background(.pGrey2)
    }
  }
}

#Preview {
  HomePostCard(
    authorName: "유가영 작가",
    authorLocation: "무대륙",
    postImagesData: [],
    postLocation: "서울 마포구 와우산로 어쩌고",
    postDate: "2024. 07. 24",
    onReportTapped: {}
  )
  .padding(.horizontal, 16)
}
