//
//  PhotographerDetailViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 4/20/25.
//

import Foundation
import Combine

final class PhotographerDetailViewModel: PhotographerDetailViewModelProtocol {
    @Published var photographerId: Int?
    var photographerIdPublisher: AnyPublisher<Int, Never> {
        $photographerId
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    @Published var selectedPackageIndex: Int = 0
    var selectedPackageIndexPublisher: AnyPublisher<Int, Never> {
        $selectedPackageIndex
            .eraseToAnyPublisher()
    }
}
