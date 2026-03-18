//
//  View+HandleKeyboard.swift
//  Features
//
//  Created by 임영택 on 3/9/26.
//

import SwiftUI

public extension View {
  func resignKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
