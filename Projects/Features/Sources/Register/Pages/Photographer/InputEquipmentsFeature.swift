//
//  InputEquipmentsFeature.swift
//  Features
//
//  Created by 임영택 on 3/17/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct InputEquipmentsFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    public var selectedPhones: [PhotographerEquipment] = []
    public var selectedCameras: [PhotographerEquipment] = []
    public var nextButtonIsDisabled: Bool { selectedPhones.isEmpty && selectedCameras.isEmpty }
    
    public init(selectedPhones: [PhotographerEquipment] = [], selectedCameras: [PhotographerEquipment] = []) {
      self.selectedPhones = selectedPhones
      self.selectedCameras = selectedCameras
    }
  }
  
  public enum Action: Hashable {
    case addPhoneButtonTapped
    case addCameraButtonTapped
    case deletePhoneTapped(PhotographerEquipment)
    case deleteCameraTapped(PhotographerEquipment)
    case nextButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case addPhone
      case addCamera
      case completed([PhotographerEquipment])
    }
  }
  
  public init() {}
  
  public var body: some ReducerOf<InputEquipmentsFeature> {
    Reduce { state, action in
      switch action {
      case .addPhoneButtonTapped:
        return .send(.delegate(.addPhone))
        
      case .addCameraButtonTapped:
        return .send(.delegate(.addCamera))
        
      case let .deletePhoneTapped(phone):
        state.selectedPhones.removeAll { $0 == phone }
        return .none
        
      case let .deleteCameraTapped(camera):
        state.selectedCameras.removeAll { $0 == camera }
        return .none
        
      case .nextButtonTapped:
        return .send(.delegate(.completed(state.selectedPhones + state.selectedCameras)))
        
      case .delegate:
        return .none
      }
    }
  }
}
