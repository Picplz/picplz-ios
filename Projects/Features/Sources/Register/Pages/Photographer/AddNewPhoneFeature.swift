//
//  AddNewPhoneFeature.swift
//  Features
//
//  Created by 임영택 on 3/17/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct AddNewPhoneFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    public var selectedBrand: String?
    public var selectedModel: String?
    public var defaultEquipments: [PhotographerEquipment] = []
    
    public init() {}
  }
  
  public enum Action: Hashable {
    case onAppear
    case fetchEquipmentsResponse(TaskResult<[PhotographerEquipment]>)
    case brandSelected(String?)
    case modelSelected(String?)
    case addButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case addEquipment(PhotographerEquipment)
    }
  }
  
  @Dependency(\.getDefaultPhotographEquipmentsUseCase) var getDefaultPhotographEquipmentsUseCase
  
  public init() {}
  
  public var body: some ReducerOf<AddNewPhoneFeature> {
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
        state.selectedModel = nil
        return .none
        
      case let .modelSelected(model):
        state.selectedModel = model
        return .none
        
      case .addButtonTapped:
        guard let brand = state.selectedBrand, let model = state.selectedModel else { return .none }
        let equipment = PhotographerEquipment(type: .phone, brand: brand, name: model)
        return .send(.delegate(.addEquipment(equipment)))
        
      case .delegate:
        return .none
      }
    }
  }
}
