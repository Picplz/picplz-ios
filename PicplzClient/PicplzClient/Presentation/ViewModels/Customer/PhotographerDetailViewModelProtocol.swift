//
//  PhotographerDetailViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 4/20/25.
//

import Foundation
import Combine

protocol PhotographerDetailViewModelProtocol {
    var photographerId: Int? { get }
    var photographerIdPublisher: AnyPublisher<Int, Never> { get }
    
    var selectedPackageIndex: Int { get }
    var selectedPackageIndexPublisher: AnyPublisher<Int, Never> { get }
}
