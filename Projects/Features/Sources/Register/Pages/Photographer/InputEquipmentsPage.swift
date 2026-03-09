//
//  InputConceptsPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI
import Domain

struct InputEquipmentsPage: View {
  @State private var selectedPhones: [PhotographerEquipment] = []
  @State private var selectedCameras: [PhotographerEquipment] = []
  
  // MARK: - Spacings
  let titletTopSpacing: CGFloat = 16
  let titleBottomSpacing: CGFloat = 30

  var body: some View {
    VStack(spacing: 0) {
      Text("촬영 기기를 선택해 주세요.")
        .typo(.pTitle)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.top, titletTopSpacing)

      ScrollView(showsIndicators: false) {
        VStack(spacing: 40) {
          VStack(spacing: 10) {
            Text("내 핸드폰")
              .typo(.pSmallTitle)
              .frame(maxWidth: .infinity, alignment: .topLeading)
              .padding(.top, titletTopSpacing)

            ForEach(selectedPhones, id: \.self) { phone in
              EquipmentPanel(equipment: phone) {
                // TODO: delete current phone
              }
            }
            
            NewEquipmentButton(placeholder: "추가하기 +") {
              // TODO: navigate to `add phone page`
            }
          }
          
          VStack(spacing: 10) {
            Text("내 카메라")
              .typo(.pSmallTitle)
              .frame(maxWidth: .infinity, alignment: .topLeading)
              .padding(.top, titletTopSpacing)
            
            ForEach(selectedCameras, id: \.self) { camera in
              EquipmentPanel(equipment: camera) {
                // TODO: delete current camera
              }
            }

            NewEquipmentButton(placeholder: "추가하기 +") {
              // TODO: navigate to `add camera page`
            }
          }
        }
      }
      .padding(.top, titleBottomSpacing)

      Spacer()

      Button1(title: "다음") {
        
      }
    }
    .padding(.horizontal)
  }
}



#Preview {
  InputEquipmentsPage()
}
