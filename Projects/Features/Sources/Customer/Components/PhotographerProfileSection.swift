//
//  PhotographerProfileSection.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI
import Domain

struct PhotographerProfileSection: View {
  let photographer: PhotographerDetail
  let isExpanded: Bool
  let onFollow: () -> Void
  let onExpand: () -> Void
  
  @State private var isTruncated: Bool = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(alignment: .center, spacing: 8) {
        // Profile Image
        Group {
          if let data = photographer.profileImageData,
             let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
              .resizable()
              .scaledToFill()
          } else {
            Circle()
              .stroke(.pGrey2)
              .overlay(
                Image(systemName: "person.fill")
                  .font(.system(size: 30))
                  .foregroundStyle(.pGrey3)
              )
          }
        }
        .frame(width: 74, height: 74)
        .clipShape(Circle())
        
        VStack(alignment: .leading, spacing: 10) {
          VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
              Text(photographer.name)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)
              
              Spacer()
              
              HStack(spacing: 12) {
                Text("\(photographer.followerCount)명")
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
              if isExpanded {
                Text("접기")
                  .typo(.pInsideTag)
                  .foregroundStyle(.pGreen120)
                  .padding(.leading, 4)
                  .background(Color.pWhite)
                  .onTapGesture {
                    onExpand()
                  }
              } else {
                Text("...더보기")
                  .typo(.pInsideTag)
                  .foregroundStyle(.pGrey6)
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
                determineTruncation(description: photographer.description, width: proxy.size.width)
              }
            }
          )
        }
      }
    }
    .padding(.horizontal, 16)
  }

  private var instagramId: String {
    photographer.instagramId
  }

  private var description: String {
    photographer.description
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
      photographer: .mock,
      isExpanded: false,
      onFollow: {},
      onExpand: {}
    )
    Divider()
    PhotographerProfileSection(
      photographer: .mock,
      isExpanded: true,
      onFollow: {},
      onExpand: {}
    )
  }
}
