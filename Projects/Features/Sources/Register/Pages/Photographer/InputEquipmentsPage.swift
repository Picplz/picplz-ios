//
//  InputConceptsPage.swift
//  Features
//
//  Created by 임영택 on 3/3/26.
//

import SwiftUI
import Domain
import ComposableArchitecture

struct InputEquipmentsPage: View {
  let store: StoreOf<InputEquipmentsFeature>
  
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

            ForEach(store.selectedPhones, id: \.self) { phone in
              EquipmentPanel(equipment: phone) {
                store.send(.deletePhoneTapped(phone))
              }
            }
            
            NewEquipmentButton(placeholder: "추가하기 +") {
              store.send(.addPhoneButtonTapped)
            }
          }
          
          VStack(spacing: 10) {
            Text("내 카메라")
              .typo(.pSmallTitle)
              .frame(maxWidth: .infinity, alignment: .topLeading)
              .padding(.top, titletTopSpacing)
            
            ForEach(store.selectedCameras, id: \.self) { camera in
              EquipmentPanel(equipment: camera) {
                store.send(.deleteCameraTapped(camera))
              }
            }

            NewEquipmentButton(placeholder: "추가하기 +") {
              store.send(.addCameraButtonTapped)
            }
          }
        }
      }
      .padding(.top, titleBottomSpacing)

      Spacer()

      Button1(title: "다음") {
        store.send(.nextButtonTapped)
      }
      .disabled(store.nextButtonIsDisabled)
    }
    .padding(.horizontal)
    .navigationTitle("촬영 기기 선택")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  InputEquipmentsPage(
    store: Store(initialState: InputEquipmentsFeature.State()) {
      InputEquipmentsFeature()
    }
  )
}
