//
//  PhotographerProfileSection.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct PhotographerProfileSection: View {
  let name: String
  let followerCount: Int
  let instagramId: String
  let description: String
  let isExpanded: Bool
  let onFollow: () -> Void
  let onExpand: () -> Void
  
  @State private var isTruncated: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(alignment: .center, spacing: 8) {
        // Profile Image
        Circle()
          .stroke(.pGrey2)
          .frame(width: 74, height: 74)
          .overlay(
            Image(systemName: "person.fill")
              .font(.system(size: 30))
              .foregroundStyle(.pGrey3)
          )
        
        VStack(alignment: .leading, spacing: 10) {
          VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
              Text(name)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
              
              Spacer()
              
              HStack(spacing: 12) {
                Text("\(followerCount)명")
                  .typo(.pCaption)
                  .foregroundStyle(.pGrey4)
                
                Button(action: onFollow) {
                  HStack(spacing: 2) {
                    Text("팔로우")
                    Image(systemName: "plus")
                      .font(.system(size: 10))
                  }
                  .typo(.pCaption)
                  .foregroundStyle(.pGrey4)
                  .padding(.horizontal, 6)
                  .padding(.vertical, 4)
                  .background(Color.pWhite)
                  .overlay(
                    RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.pGrey2, lineWidth: 1)
                  )
                }
              }
            }
            
            HStack(spacing: 4) {
              Image(.insta)
                .font(.system(size: 10))
                .foregroundStyle(.pBlack)
              
              Text(instagramId)
                .font(.system(size: 12))
                .foregroundStyle(.pGrey3)
                .underline()
            }
            .padding(.top, 4)
          }
          
          // Description
          ZStack(alignment: .bottomTrailing) {
            Text(description)
              .typo(.pCaption)
              .foregroundStyle(.pGrey6)
              .lineLimit(isExpanded ? nil : 2)
              .fixedSize(horizontal: false, vertical: true)
            
            if isTruncated {
              if !isExpanded {
                Text("...더보기")
                  .typo(.pInsideTag)
                  .foregroundStyle(.pGrey6)
                  .padding(.leading, 4)
                  .background(Color.pWhite)
                  .onTapGesture {
                    onExpand()
                  }
              } else {
                Text("접기")
                  .typo(.pInsideTag)
                  .foregroundStyle(.pGreen120)
                  .padding(.leading, 4)
                  .background(Color.pWhite)
                  .onTapGesture {
                    onExpand()
                  }
              }
            }
          }
          .overlay(
            GeometryReader { proxy in
              Color.clear.onAppear {
                determineTruncation(description: description, width: proxy.size.width)
              }
            }
          )
        }
      }
    }
    .padding(.horizontal, 16)
  }

  private func determineTruncation(description: String, width: CGFloat) {
    let font = TypographyStyle.pCaption.uiFont
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = description.boundingRect(
      with: constraintRect,
      options: .usesLineFragmentOrigin,
      attributes: [.font: font],
      context: nil
    )
    
    let singleLineHeight = "가".size(withAttributes: [.font: font]).height
    isTruncated = boundingBox.height > (singleLineHeight * 2.2)
  }
}

#Preview {
  VStack {
    PhotographerProfileSection(
      name: "유가영 작가",
      followerCount: 112,
      instagramId: "Gayoung",
      description: "10/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 어쩌고저쩌고... 아이고 쉽지 않다 하하하",
      isExpanded: false,
      onFollow: {},
      onExpand: {}
    )
    Divider()
    PhotographerProfileSection(
      name: "유가영 작가",
      followerCount: 112,
      instagramId: "Gayoung",
      description: "10/31 이후 예약 가능합니다. 어쩌고저쩌고 적으면 최대 두 줄까지 적을 수 있습니다. 어쩌고저쩌고... 아이고 쉽지 않다 하하하",
      isExpanded: true,
      onFollow: {},
      onExpand: {}
    )
  }
}
