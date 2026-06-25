//
//  PortfolioAddFeature.swift
//  Features
//
//  Created by wonsik on 4/25/26.
//

import ComposableArchitecture
import Domain
import Foundation
import UIKit

@Reducer
public struct PortfolioAddFeature {
    public static let maxImageCount: Int = 10

    public struct SelectedImage: Equatable, Identifiable, Hashable {
        public let id: String
        public let image: UIImage
        public let creationDate: Date?

        public init(id: String = UUID().uuidString, image: UIImage, creationDate: Date? = nil) {
            self.id = id
            self.image = image
            self.creationDate = creationDate
        }

        public static func == (lhs: SelectedImage, rhs: SelectedImage) -> Bool {
            lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    @ObservableState
    public struct State: Equatable, Hashable {
        var editingId: String? = nil   // nil = 신규 등록, 값 있음 = 수정 모드
        var selectedImages: [SelectedImage] = []
        var shootingDate: Date? = nil
        var location: String? = nil
        var showReorderGuide: Bool = false
        var hasShownReorderGuide: Bool = false
        var isDatePickerPresented: Bool = false
        var pendingDate: Date = Date()
        var isExitAlertPresented: Bool = false
        @Presents var locationSearch: LocationSearchFeature.State?

        var isEditMode: Bool { editingId != nil }

        var isFormValid: Bool {
            // 수정 모드에서는 기존 이미지가 유지되므로 selectedImages가 비어도 OK
            let hasImages = !selectedImages.isEmpty || isEditMode
            return hasImages && shootingDate != nil
        }

        var hasInput: Bool {
            !selectedImages.isEmpty || shootingDate != nil || location != nil
        }

        var shootingDateText: String? {
            guard let date = shootingDate else { return nil }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일"
            return formatter.string(from: date)
        }

        public init(
            editingId: String? = nil,
            selectedImages: [SelectedImage] = [],
            shootingDate: Date? = nil,
            location: String? = nil
        ) {
            self.editingId = editingId
            self.selectedImages = selectedImages
            self.shootingDate = shootingDate
            self.location = location
            self.pendingDate = shootingDate ?? Date()
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case exitConfirmed
        case imagesSelected([SelectedImage])
        case removeImage(String)
        case moveImage(from: Int, to: Int)
        case shootingDateTapped
        case dateConfirmed
        case locationTapped
        case registerButtonTapped
        case hideReorderGuide
        case locationSearch(PresentationAction<LocationSearchFeature.Action>)
    }

    public init() {}

    public var body: some ReducerOf<PortfolioAddFeature> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .backButtonTapped:
                if state.hasInput {
                    state.isExitAlertPresented = true
                    return .none
                }
                return .send(.exitConfirmed)
            case .exitConfirmed:
                state.isExitAlertPresented = false
                return .none
            case let .imagesSelected(images):
                let previousCount = state.selectedImages.count
                let remaining = Self.maxImageCount - state.selectedImages.count
                let newImages = Array(images.prefix(remaining))

                state.selectedImages.append(contentsOf: newImages)

                if state.shootingDate == nil, let firstDate = newImages.first?.creationDate {
                    state.shootingDate = firstDate
                    state.pendingDate = firstDate
                }

                let shouldShowReorderGuide =
                    !state.hasShownReorderGuide &&
                    previousCount <= 1 &&
                    state.selectedImages.count >= 2

                if shouldShowReorderGuide {
                    state.showReorderGuide = true
                    state.hasShownReorderGuide = true
                    return .run { send in
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        await send(.hideReorderGuide)
                    }
                }

                return .none
            case let .removeImage(id):
                state.selectedImages.removeAll { $0.id == id }
                return .none
            case let .moveImage(from, to):
                guard from != to,
                      from >= 0, from < state.selectedImages.count,
                      to >= 0, to < state.selectedImages.count else { return .none }
                let image = state.selectedImages.remove(at: from)
                state.selectedImages.insert(image, at: to)
                return .none
            case .shootingDateTapped:
                state.pendingDate = state.shootingDate ?? Date()
                state.isDatePickerPresented = true
                return .none
            case .dateConfirmed:
                state.shootingDate = state.pendingDate
                state.isDatePickerPresented = false
                return .none
            case .locationTapped:
                state.locationSearch = LocationSearchFeature.State()
                return .none
            case .locationSearch(.presented(.locationSelected(let area))):
                state.location = area.name
                state.locationSearch = nil
                return .none
            case .locationSearch:
                return .none
            case .registerButtonTapped:
                return .none
            case .hideReorderGuide:
                state.showReorderGuide = false
                return .none
            }
        }
        .ifLet(\.$locationSearch, action: \.locationSearch) {
            LocationSearchFeature()
        }
    }
}
