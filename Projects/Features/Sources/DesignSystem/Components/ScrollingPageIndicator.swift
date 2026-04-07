//
//  ScrollingPageIndicator.swift
//  Features
//
//  Created by wonsik on 4/7/26.
//

import SwiftUI

/// 인스타그램 스타일 페이지 인디케이터
/// - 최대 5개의 dot을 표시하며, 현재 위치 기준으로 윈도우가 이동
/// - 현재 dot은 큰 크기, 인접 dot은 중간 크기, 먼 dot은 작은 크기
struct ScrollingPageIndicator: View {
    let currentPage: Int
    let totalPages: Int

    private let maxVisibleDots = 5
    private let largeDotSize: CGFloat = 6
    private let mediumDotSize: CGFloat = 5
    private let smallDotSize: CGFloat = 4
    private let dotSpacing: CGFloat = 6

    var body: some View {
        if totalPages <= 0 {
            EmptyView()
        } else if totalPages <= 3 {
            // 3개 이하: 기본 PageIndicator 사용
            PageIndicator(currentPage: currentPage, totalPages: totalPages)
        } else if totalPages <= maxVisibleDots {
            // 4~5개: 모든 dot 표시 (크기 차등)
            HStack(spacing: dotSpacing) {
                ForEach(0..<totalPages, id: \.self) { index in
                    dot(for: index)
                }
            }
        } else {
            // 5개 초과: 윈도우 기반 표시
            HStack(spacing: dotSpacing) {
                ForEach(visibleRange, id: \.self) { index in
                    dot(for: index)
                }
            }
        }
    }

    private var visibleRange: [Int] {
        let half = maxVisibleDots / 2
        let start: Int
        let end: Int

        if currentPage <= half {
            start = 0
            end = maxVisibleDots - 1
        } else if currentPage >= totalPages - 1 - half {
            start = totalPages - maxVisibleDots
            end = totalPages - 1
        } else {
            start = currentPage - half
            end = currentPage + half
        }

        return Array(start...end)
    }

    @ViewBuilder
    private func dot(for index: Int) -> some View {
        let distance = abs(currentPage - index)
        let size = dotSize(for: distance)

        Circle()
            .fill(index == currentPage ? Color(.pBlack) : Color(.pGrey3))
            .frame(width: size, height: size)
            .animation(.easeInOut(duration: 0.2), value: currentPage)
    }

    private func dotSize(for distance: Int) -> CGFloat {
        switch distance {
        case 0, 1:
            return largeDotSize
        case 2:
            return mediumDotSize
        default:
            return smallDotSize
        }
    }
}

#Preview("5개 이하") {
    VStack(spacing: 20) {
        ScrollingPageIndicator(currentPage: 0, totalPages: 3)
        ScrollingPageIndicator(currentPage: 1, totalPages: 4)
        ScrollingPageIndicator(currentPage: 2, totalPages: 5)
    }
}

#Preview("5개 초과") {
    VStack(spacing: 20) {
        ScrollingPageIndicator(currentPage: 0, totalPages: 8)
        ScrollingPageIndicator(currentPage: 3, totalPages: 8)
        ScrollingPageIndicator(currentPage: 5, totalPages: 8)
        ScrollingPageIndicator(currentPage: 7, totalPages: 8)
    }
}
