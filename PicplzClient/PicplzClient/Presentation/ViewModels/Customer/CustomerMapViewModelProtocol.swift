//
//  CustomerMapViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 4/5/25.
//

import Foundation
import Combine

protocol CustomerMapViewModelDelegate {
    func selectPhotographerDetail(photographerId: Int)
}

protocol CustomerMapViewModelProtocol {
    var delegate: CustomerMapViewModelDelegate? { get set }
    
    var shortAddress: String? { get }
    var shortAddressPublisher: AnyPublisher<String, Never> { get }
    
    func refreshButtonTapped()
    func onLoad()
    
    func photographerSelected(id: Int)
}
