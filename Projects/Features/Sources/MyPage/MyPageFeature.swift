//
//  MyPageFeature.swift
//  Features
//
//  Created by wonsik on 3/26/26.
//

import ComposableArchitecture
import Domain
import Foundation

@Reducer
public struct MyPageFeature {
    @ObservableState
    public struct State: Equatable {
        
        public init() {}
    }
    
    public enum Action: Hashable {
        
    }
    
    public init() { }
    
    public var body: some ReducerOf<MyPageFeature> {
        Reduce { state, action in
            return .none
        }
    }
}
