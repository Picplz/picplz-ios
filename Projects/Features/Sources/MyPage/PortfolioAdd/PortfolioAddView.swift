//
//  PortfolioAddView.swift
//  Features
//
//  Created by wonsik on 4/25/26.
//

import Photos
import PhotosUI
import SwiftUI
import ComposableArchitecture
import UniformTypeIdentifiers

struct PortfolioAddView: View {
    @Bindable var store: StoreOf<PortfolioAddFeature>
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var draggingImageID: String?

    var body: some View {
        VStack(spacing: 0) {
            SubNavigationBar(title: "포트폴리오 등록") {
                store.send(.backButtonTapped)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    imageSection
                        .padding(.top, 20)
                        .padding(.bottom, 24)

                    shootingDateRow
                        .padding(.top, 16)
                        .padding(.bottom, 8)

                    divider

                    locationRow
                        .padding(.top, 36)
                        .padding(.bottom, 8)

                    divider
                }
            }

            Spacer()

            registerButton
        }
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
        .sheet(isPresented: $store.isDatePickerPresented) {
            datePickerSheet
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.hidden)
        }
        .sheet(
            item: $store.scope(state: \.locationSearch, action: \.locationSearch)
        ) { locationStore in
            LocationSearchView(store: locationStore)
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }

    // MARK: - 사진 추가

    private var imageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                addImageButton

                ForEach(store.selectedImages) { selectedImage in
                    PortfolioImageCell(
                        store: store,
                        selectedImage: selectedImage,
                        draggingImageID: $draggingImageID
                    )
                }
            }
            .padding(.vertical, 8)
        }
        .overlay(alignment: .bottomTrailing) {
            if store.showReorderGuide {
                Image(.profileToastMessage)
                    .transition(.opacity)
                    .offset(y: 40)
            }
        }
        .animation(.easeInOut, value: store.showReorderGuide)
    }

    private var addImageButton: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: max(PortfolioAddFeature.maxImageCount - store.selectedImages.count, 0),
            matching: .images
        ) {
            VStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(.pGrey3)

                Text("사진 추가")
                    .typo(.pParagraph)
                    .foregroundStyle(.pGrey4)

                Text("\(store.selectedImages.count)/\(PortfolioAddFeature.maxImageCount)")
                    .typo(.pCaption)
                    .foregroundStyle(.pGrey4)
            }
            .frame(width: 120, height: 120)
            .background(Color(.pGrey2))
        }
        .onChange(of: selectedPhotos) { _, newValue in
            handleSelectedPhotos(newValue)
        }
    }

    // MARK: - 촬영 날짜

    private var shootingDateRow: some View {
        Button {
            store.send(.shootingDateTapped)
        } label: {
            HStack {
                Text("촬영 날짜")
                    .typo(.pSmallTitle)
                    .foregroundStyle(.pBlack)

                Spacer()

                if let dateText = store.shootingDateText {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                            .foregroundStyle(.pGrey4)

                        Text(dateText)
                            .typo(.pParagraph)
                            .foregroundStyle(.pGrey4)
                    }
                }

                Image(.rightGoBlack)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - 장소 추가

    private var locationRow: some View {
        Button {
            store.send(.locationTapped)
        } label: {
            HStack {
                Text("장소 추가")
                    .typo(.pSmallTitle)
                    .foregroundStyle(.pBlack)

                Spacer()

                if let location = store.location {
                    Text(location)
                        .typo(.pParagraph)
                        .foregroundStyle(.pGrey4)
                }

                Image(.rightGoBlack)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - 등록하기 버튼

    private var registerButton: some View {
        Button1(title: "등록하기", isActive: store.isFormValid) {
            store.send(.registerButtonTapped)
        }
        .padding(.bottom, 16)
    }

    // MARK: - 구분선

    private var divider: some View {
        Rectangle()
            .fill(Color(.pGrey3))
            .frame(height: 1)
    }

    // MARK: - 날짜 선택 바텀시트

    private var datePickerSheet: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.pGrey2))
                .frame(width: 40, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)

            Text("촬영 날짜를 선택해주세요")
                .typo(.pTitle)
                .foregroundStyle(.pBlack)
                .padding(.top, 8)
                .padding(.bottom, 16)

            DatePicker(
                "",
                selection: $store.pendingDate,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .padding(.vertical, 20)

            Button1(title: "확인") {
                store.send(.dateConfirmed)
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }

    // MARK: - 사진 선택 처리

    private func handleSelectedPhotos(_ items: [PhotosPickerItem]) {
        guard !items.isEmpty else { return }

        Task {
            var newImages: [PortfolioAddFeature.SelectedImage] = []

            for item in items {
                guard let data = try? await item.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { continue }

                var creationDate: Date? = nil
                if let identifier = item.itemIdentifier {
                    let result = PHAsset.fetchAssets(
                        withLocalIdentifiers: [identifier],
                        options: nil
                    )
                    creationDate = result.firstObject?.creationDate
                }

                newImages.append(
                    PortfolioAddFeature.SelectedImage(
                        image: uiImage,
                        creationDate: creationDate
                    )
                )
            }

            await MainActor.run {
                store.send(.imagesSelected(newImages))
                selectedPhotos = []
            }
        }
    }

}

private struct PortfolioImageCell: View {
    let store: StoreOf<PortfolioAddFeature>
    let selectedImage: PortfolioAddFeature.SelectedImage
    @Binding var draggingImageID: String?

    var body: some View {
        let isRepresentative = store.selectedImages.first?.id == selectedImage.id

        ZStack(alignment: .topTrailing) {
            Image(uiImage: selectedImage.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipped()
                .overlay(
                    Rectangle()
                        .strokeBorder(Color(.pGreen120), lineWidth: 2)
                        .opacity(isRepresentative ? 1 : 0)
                )

            Text("대표")
                .typo(.pInsideTag)
                .foregroundStyle(.pWhite)
                .frame(width: 34, height: 20)
                .background(Color(.pGreen120))
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 6,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                ))
                .opacity(isRepresentative ? 1 : 0)

            Button {
                store.send(.removeImage(selectedImage.id))
            } label: {
                Image(.addProfileX)
            }
            .padding(4)
            .opacity(isRepresentative ? 0 : 1)
            .allowsHitTesting(!isRepresentative)
        }
        .frame(width: 120, height: 120)
        .onDrag {
            draggingImageID = selectedImage.id
            return NSItemProvider(object: selectedImage.id as NSString)
        }
        .onDrop(of: [.text], delegate: ImageReorderDropDelegate(
            targetImage: selectedImage,
            allImages: store.selectedImages,
            draggingImageID: $draggingImageID,
            onMove: { from, to in
                store.send(.moveImage(from: from, to: to))
            }
        ))
    }
}

private struct ImageReorderDropDelegate: DropDelegate {
    let targetImage: PortfolioAddFeature.SelectedImage
    let allImages: [PortfolioAddFeature.SelectedImage]
    @Binding var draggingImageID: String?
    let onMove: (Int, Int) -> Void

    func performDrop(info: DropInfo) -> Bool {
        draggingImageID = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggingID = draggingImageID,
              draggingID != targetImage.id,
              let fromIndex = allImages.firstIndex(where: { $0.id == draggingID }),
              let toIndex = allImages.firstIndex(where: { $0.id == targetImage.id })
        else { return }

        onMove(fromIndex, toIndex)
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
}

#Preview {
    PortfolioAddView(
        store: Store(
            initialState: PortfolioAddFeature.State()
        ) {
            PortfolioAddFeature()
        }
    )
}
