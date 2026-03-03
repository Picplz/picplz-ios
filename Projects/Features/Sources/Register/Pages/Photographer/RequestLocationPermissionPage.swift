//
//  RequestLocationPermissionPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import Domain
import PhotosUI
import SwiftUI
import CoreLocation

struct RequestLocationPermissionPage: View {
  // MARK: - Spacings
  let topMargin: CGFloat = 108
  let titleSpacing: CGFloat = 32
  
  let attributedTitle: AttributedString = {
    var attributed = AttributedString("앱 서비스 이용을 위해\n위치 접근 권한이 필요해요")
    guard let range = attributed.range(of: "위치 접근 권한") else { return attributed }
    attributed[range].foregroundColor = .pGreen120
    return attributed
  }()

  var body: some View {
    VStack(spacing: 0) {
      Image(.shieldCircle)
        .padding(.top, topMargin)
      
      Text(attributedTitle)
        .typo(.pTitle)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, titleSpacing)
      
      Text("""
        더 나은 서비스 제공을 위해 권한을 요청드려요.
        동의하지 않아도 서비스를 이용할 수 있지만, 
        다수 기능의 이용이 제한될 수 있어요.
        """)
      .typo(.pParagraph)
      .foregroundStyle(.pGrey4)
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity, alignment: .center)
      
      Spacer()
      
      Button1(title: "다음") {
        // 위치 정보 확인
      }
    }
    .padding(.horizontal)
  }
}

#Preview {
  RequestLocationPermissionPage()
}
