//
//  PicplzApp.swift
//  ProjectDescriptionHelpers
//
//  Created by 임영택 on 12/18/25.
//

import Features
import SwiftUI
import ComposableArchitecture

@main
struct PicplzApp: App {
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(store: PicplzApp.store)
    }
  }
}
