//
//  InputConceptsFeature.swift
//  Features
//
//  Created by 임영택 on 3/18/26.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct InputConceptsFeature {
  @ObservableState
  public struct State: Equatable, Hashable {
    public var concepts: [Concept] = Concept.defaultConcepts
    
    public init() {}
  }
  
  public enum Action: Hashable {
    case conceptToggled(Int)
    case conceptKeywordEdited(Int, String)
    case addNewConcept(String)
    case nextButtonTapped
    case delegate(Delegate)
    
    public enum Delegate: Hashable {
      case completed([String])
    }
  }
  
  public init() {}
  
  public var body: some ReducerOf<InputConceptsFeature> {
    Reduce { state, action in
      switch action {
      case let .conceptToggled(index):
        state.concepts[index].toggle()
        return .none
        
      case let .conceptKeywordEdited(index, newKeyword):
        state.concepts[index].editKeyword(to: newKeyword)
        return .none
        
      case let .addNewConcept(keyword):
        let nextId = (state.concepts.last?.id ?? 0) + 1
        state.concepts.append(
          Concept(
            id: nextId,
            keyword: keyword,
            isSelected: true,
            isUserDefined: true
          )
        )
        return .none
        
      case .nextButtonTapped:
        let selectedMoods = state.concepts
          .filter { $0.isSelected }
          .map { $0.keyword }
        return .send(.delegate(.completed(selectedMoods)))
        
      case .delegate:
        return .none
      }
    }
  }
}
