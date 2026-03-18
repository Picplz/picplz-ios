//
//  AddNewCameraFeature.swift
//  Features
//
//  Created by 임영택 on 3/17/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct AddNewCameraFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    public var selectedBrand: String?
    public var selectedTypeDisplayName: String?
    public var selectedModel: String = ""
    public var defaultEquipments: [PhotographerEquipment] = []
    
    public init() {}
  }
  
  public enum Action: Hashable {
    case onAppear
    case fetchEquipmentsResponse(TaskResult<[PhotographerEquipment]>)
    case brandSelected(String?)
    case typeSelected(String?)
    case modelChanged(String)
    case addButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case addEquipment(PhotographerEquipment)
    }
  }
  
  @Dependency(\.getDefaultPhotographEquipmentsUseCase) var getDefaultPhotographEquipmentsUseCase
  
  public init() {}
  
  public var body: some ReducerOf<AddNewCameraFeature> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.fetchEquipmentsResponse(TaskResult {
            try await getDefaultPhotographEquipmentsUseCase.execute()
          }))
        }
        
      case let .fetchEquipmentsResponse(.success(equipments)):
        state.defaultEquipments = equipments
        return .none
        
      case .fetchEquipmentsResponse(.failure):
        return .none
        
      case let .brandSelected(brand):
        state.selectedBrand = brand
        return .none
        
      case let .typeSelected(type):
        state.selectedTypeDisplayName = type
        return .none
        
      case let .modelChanged(model):
        state.selectedModel = model
        return .none
        
      case .addButtonTapped:
        guard let brand = state.selectedBrand, 
              let typeName = state.selectedTypeDisplayName,
              let cameraType = PhotographerEquipment.EquipmentType.CameraType.allCases.first(where: { $0.displayName == typeName })
        else { return .none }
        
        let equipment = PhotographerEquipment(
          type: .camera(cameraType),
          brand: brand,
          name: state.selectedModel
        )
        return .send(.delegate(.addEquipment(equipment)))
        
      case .delegate:
        return .none
      }
    }
  }
}

extension PhotographerEquipment.EquipmentType.CameraType {
  public var displayName: String {
    switch self {
    case .campactCamera:
      "디지털 카메라"
    case .mirrorlessCamera:
      "미러리스 카메라"
    case .dslrCamera:
      "DSLR 카메라"
    case .filmCamera:
      "필름 카메라"
    case .unknown:
      "기타"
    }
  }
}
