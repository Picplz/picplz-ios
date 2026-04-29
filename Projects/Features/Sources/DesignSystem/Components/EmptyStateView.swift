//
//  EmptyStateView.swift
//  Features
//
//  Created by wonsik on 4/11/26.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .typo(.pSmallTitle)
                .foregroundStyle(.pBlack)

            Image(.notfound)

            Text(description)
                .typo(.pParagraph)
                .foregroundStyle(.pGrey4)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        title: "아직 작성한 리뷰가 없어요",
        description: "촬영이 끝난 작가에게 리뷰를 남겨보세요"
    )
}
