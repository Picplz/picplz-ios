//
//  ColorSystem.swift
//  Presentation
//
//  Created by 임영택 on 1/19/26.
//

import Foundation
import SwiftUI

/**
 예시 뷰
 */
struct ColorPalette: View {
  typealias ColorName = String
  
  private let colors = ColorItem.colors
  
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 8) {
          ForEach(colors) { item in
            ColorChip(item: item)
          }
        }
      }
      .navigationTitle("Picplz Color System")
      .padding()
    }
  }
}

extension ColorPalette {
  private struct ColorChip: View {
    let item: ColorItem
    
    var body: some View {
      ZStack {
        Rectangle()
          .fill(Color(item.resource))
          .border(.pBlack, width: 1)
          .aspectRatio(1.0, contentMode: .fit)
        
        VStack {
          Spacer()
          
          Text(item.title)
            .padding(.bottom, 4)
        }
      }
    }
  }
}

extension ColorPalette {
  private struct ColorItem: Hashable, Identifiable {
    let title: String
    let resource: ColorResource
    
    var id: String {
      title
    }
    
    static let colors: [ColorItem] = [
      .init(title: "white", resource: .pWhite),
      .init(title: "grey1", resource: .pGrey1),
      .init(title: "grey2", resource: .pGrey2),
      .init(title: "grey3", resource: .pGrey3),
      .init(title: "grey4", resource: .pGrey4),
      .init(title: "grey5", resource: .pGrey5),
      .init(title: "grey6", resource: .pGrey6),
      .init(title: "black", resource: .pBlack),
      .init(title: "30 point green", resource: .pGreen30),
      .init(title: "100 point green", resource: .pGreen100),
      .init(title: "120 point green", resource: .pGreen120),
      .init(title: "150 deep green", resource: .pGreen150),
      .init(title: "red", resource: .pRed),
      .init(title: "pink1", resource: .pPink1),
      .init(title: "pink2", resource: .pPink2),
    ]
  }
}

#Preview {
  ColorPalette()
}
