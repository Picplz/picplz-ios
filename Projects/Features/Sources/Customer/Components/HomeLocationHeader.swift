//
//  HomeLocationHeader.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import SwiftUI

struct HomeLocationHeader: View {
  let location: String
  let onLocationTapped: () -> Void
  let onNotificationTapped: () -> Void
  let onProfileTapped: () -> Void
  
  var body: some View {
    HStack(spacing: 0) {
      Button(action: onLocationTapped) {
        HStack(spacing: 2) {
          Text(location)
            .typo(.pBoldParagraph)
            .foregroundStyle(.pBlack)
          
          Image(systemName: "chevron.down")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.pBlack)
        }
      }
      
      Spacer()
      
      HStack(spacing: 16) {
        Button(action: onProfileTapped) {
          Image(systemName: "person.badge.plus")
            .font(.system(size: 20))
            .foregroundStyle(.pBlack)
        }
        
        Button(action: onNotificationTapped) {
          Image(systemName: "bell")
            .font(.system(size: 20))
            .foregroundStyle(.pBlack)
        }
      }
    }
    .padding(.horizontal, 16)
    .frame(height: 44)
  }
}

#Preview {
  HomeLocationHeader(
    location: "서울 전체",
    onLocationTapped: {},
    onNotificationTapped: {},
    onProfileTapped: {}
  )
}
