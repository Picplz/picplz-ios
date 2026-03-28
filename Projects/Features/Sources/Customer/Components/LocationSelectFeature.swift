//
//  LocationSelectFeature.swift
//  Features
//
//  Created by 임영택 on 3/28/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct LocationSelectFeature {
  @ObservableState
  public struct State: Equatable {
    public var selectedCity: String = "서울"
    public var selectedDistrict: String = "서울 전체"
    
    public let cities: [String] = ["서울", "경기", "인천", "부산", "제주"]
    public var districts: [String] {
      // 더미 데이터
      if selectedCity == "서울" {
        return ["서울 전체", "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구"]
      } else {
        return ["\(selectedCity) 전체", "지역 1", "지역 2", "지역 3"]
      }
    }
    
    public init() {}
  }
  
  public enum Action: Hashable {
    case cityTapped(String)
    case districtTapped(String)
    case applyButtonTapped
  }
  
  public init() {}
  
  public var body: some ReducerOf<LocationSelectFeature> {
    Reduce { state, action in
      switch action {
      case let .cityTapped(city):
        state.selectedCity = city
        state.selectedDistrict = "\(city) 전체"
        return .none
        
      case let .districtTapped(district):
        state.selectedDistrict = district
        return .none
        
      case .applyButtonTapped:
        return .none
      }
    }
  }
}
