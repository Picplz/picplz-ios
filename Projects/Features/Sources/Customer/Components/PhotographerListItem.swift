//
//  PhotographerListItem.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct PhotographerListItem: View {
  let photographer: Photographer
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack(spacing: 0) {
        HStack(alignment: .top, spacing: 10) {
          // Profile Image
          if let data = photographer.profileImageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFill()
              .frame(width: 88, height: 88)
              .cornerRadius(5)
              .clipped()
          } else {
            Image(.photographerProfilePlaceholder)
              .resizable()
              .scaledToFill()
              .frame(width: 88, height: 88)
              .cornerRadius(5)
              .clipped()
          }
          
          VStack(alignment: .leading, spacing: 4) {
            HStack {
              Text(photographer.name)
                .typo(.pBoldParagraph)
                .foregroundStyle(.pBlack)
              
              Spacer()
              
              if photographer.isFastShootAvailable {
                HStack(spacing: 4) {
                  Circle()
                    .fill(.pGreen120)
                    .frame(width: 6, height: 6)
                  
                  Text("빠른촬영")
                    .typo(.pCaption)
                    .foregroundStyle(.pGreen120)
                }
              }
            }
            
            Text(photographer.districts)
              .typo(.pParagraph)
              .foregroundStyle(.pGrey4)
            
            Spacer().frame(height: 12)
            
            ScrollView(.horizontal) {
              HStack(spacing: 4) {
                ForEach(photographer.tags, id: \.self) { tag in
                  Text(tag)
                    .typo(.pParagraph)
                    .foregroundStyle(.pGrey4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.pGrey1)
                    .cornerRadius(5)
                }
              }
            }
            .scrollIndicators(.hidden)
          }
          
          Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        
        Divider()
          .background(.pGrey2)
          .padding(.horizontal, 16)
      }
    }
  }
}

#Preview {
  PhotographerListItem(
    photographer: Photographer(
      id: UUID(),
      name: "유가영 작가",
      districts: "마포구, 서대문구",
      tags: ["#을지로 감성", "#MZ 감성"],
      isFastShootAvailable: true,
      profileImageData: nil
    ),
    action: {}
  )
}
