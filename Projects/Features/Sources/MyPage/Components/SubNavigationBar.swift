//
//  SubNavigationBar.swift
//  Features
//
//  Created by wonsik on 4/2/26.
//

import SwiftUI

struct SubNavigationBar: View {
    let title: String
    let onBackTapped: () -> Void

    var body: some View {
        HStack {
            Button {
                onBackTapped()
            } label: {
                Image(.leftGoBlack)
            }
            Spacer()
        }
        .overlay {
            Text(title)
                .typo(.pParagraph)
        }
    }
}
