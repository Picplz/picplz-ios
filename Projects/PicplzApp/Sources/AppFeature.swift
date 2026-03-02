//
//  AppFeature.swift
//  PicplzApp
//
//  Created by 임영택 on 1/20/26.
//

import ComposableArchitecture
import Domain
import Features

@Reducer
struct AppFeature {
  @ObservableState
  enum State: Equatable {
    case splash(SplashFeature.State)
    case main(MainFeature.State)
    
    init() {
      self = .splash(SplashFeature.State())
    }
  }
  
  enum Action {
    case onAppear
    case splash(SplashFeature.Action)
    case main(MainFeature.Action)
  }
  
  var body: some ReducerOf<AppFeature> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        state = .splash(SplashFeature.State())
        return .none
      case let .splash(.delegate(.dataLoaded(data))):
        if let _ = data.tokens {
          state = .main(.customer(CustomerFeature.State())) // TODO: 작가, 고객 분기
        } else {
          state = .main(MainFeature.State())
        }
        
        return .none
      case .splash:
        return .none
      case .main:
        return .none
      }
    }
    .ifCaseLet(\.splash, action: \.splash) {
      SplashFeature()
    }
    .ifCaseLet(\.main, action: \.main) {
      MainFeature()
    }
  }
}
