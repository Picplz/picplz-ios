//
//  SelectPrimaryAreaFeature.swift
//  Features
//
//  Created by 임영택 on 3/15/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct SelectPrimaryAreaFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    var searchQuery: String = ""
    var areas: [Area] = []
    var selectedAreas: [Area] = []
    var toastItem: ToastItem?
    
    var isShowNotFound: Bool {
      !searchQuery.isEmpty && areas.isEmpty
    }
    
    var searchResultTitle: String {
      searchQuery.isEmpty ? "인근 지역" : "‘\(searchQuery)’ 검색 결과"
    }
    
    public init() {}
  }
  
  public enum Action: Hashable {
    case onAppear
    case searchQueryChanged(String)
    case nearDongsResponse(TaskResult<[Area]>)
    case searchAreasResponse(TaskResult<[Area]>)
    case areaTapped(Area)
    case deleteAreaTapped(Area)
    case toastItemChanged(ToastItem?)
    case nextButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case completed([Area])
    }
  }
  
  @Dependency(\.getNearDongsUseCase) var getNearDongsUseCase
  @Dependency(\.searchAreasUseCase) var searchAreasUseCase
  @Dependency(\.mainQueue) var mainQueue
  
  private enum CancelID { case search }
  
  public init() {}
  
  public var body: some ReducerOf<SelectPrimaryAreaFeature> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          await send(.nearDongsResponse(TaskResult { try await getNearDongsUseCase.execute() }))
        }
        
      case let .searchQueryChanged(query):
        state.searchQuery = query
        
        if query.isEmpty {
          return .run { send in
            await send(.nearDongsResponse(TaskResult { try await getNearDongsUseCase.execute() }))
          }
          .debounce(id: CancelID.search, for: 0.3, scheduler: mainQueue)
        }
        
        return .run { send in
          await send(.searchAreasResponse(TaskResult { try await searchAreasUseCase.execute(query) }))
        }
        .debounce(id: CancelID.search, for: 0.3, scheduler: mainQueue)
        
      case let .nearDongsResponse(.success(areas)):
        state.areas = areas
        return .none
        
      case let .nearDongsResponse(.failure(error)):
        state.toastItem = ToastItem(message: "인근 지역 정보를 가져오지 못했습니다. (\(error.localizedDescription))")
        return .none
        
      case let .searchAreasResponse(.success(areas)):
        state.areas = areas
        return .none
        
      case let .searchAreasResponse(.failure(error)):
        state.toastItem = ToastItem(message: "검색 결과를 가져오지 못했습니다. (\(error.localizedDescription))")
        return .none
        
      case let .areaTapped(area):
        guard !state.selectedAreas.contains(area) else {
          state.toastItem = ToastItem(message: "이미 선택한 항목입니다.")
          return .none
        }

        guard state.selectedAreas.count < 5 else {
          state.toastItem = ToastItem(message: "활동 지역은 최대 5개까지 선택할 수 있습니다.")
          return .none
        }

        state.selectedAreas.append(area)
        return .none
        
      case let .deleteAreaTapped(area):
        if let index = state.selectedAreas.firstIndex(of: area) {
          state.selectedAreas.remove(at: index)
        }
        return .none
        
      case let .toastItemChanged(item):
        state.toastItem = item
        return .none
        
      case .nextButtonTapped:
        return .send(.delegate(.completed(state.selectedAreas)))
        
      case .delegate:
        return .none
      }
    }
  }
}
