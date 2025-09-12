//
//  CustomerMapViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 4/5/25.
//

import Foundation
import Combine
import MapKit
import OSLog

final class CustomerMapViewModel: NSObject, CustomerMapViewModelProtocol {
    weak var delegate: CustomerMapViewModelDelegate?

    @Published var shortAddress: String?
    var shortAddressPublisher: AnyPublisher<String, Never> {
        $shortAddress
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    private let getShortAddressUseCase: GetShortAddressUseCase
    private var subscriptions: Set<AnyCancellable> = []
    private let log = Logger.of("CustomerMapViewModel")

    init(getShortAddressUseCase: GetShortAddressUseCase) {
        self.getShortAddressUseCase = getShortAddressUseCase
        super.init()

        self.getShortAddressUseCase.shortAddressPublisher
            .sink { shortAddress in
                self.shortAddress = shortAddress
            }
            .store(in: &subscriptions)
    }

    func refreshButtonTapped() {
        updateShortAddress()
    }

    func onLoad() {
        updateShortAddress()
    }

    private func updateShortAddress() {
        Task { @MainActor in
            self.shortAddress = await self.getShortAddressUseCase.getShortAddress()
        }
    }

    func photographerSelected(id: Int) {
        delegate?.selectPhotographerDetail(photographerId: id)
    }
}
