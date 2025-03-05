//
//  SignUpPhotographerCareerPeriodPageViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import Combine

protocol SignUpPhotographerCareerPeriodPageViewModelProtocol: SignUpVIewModelProtocol {
    var years: Int { get }
    var yearsPublisher: AnyPublisher<Int, Never> { get }
    
    var months: Int { get }
    var monthsPublisher: AnyPublisher<Int, Never> { get }
    
    var nextButtonEnabled: Bool { get }
    var nextButtonEnabledPublisher: Published<Bool>.Publisher { get }
    
    func didPeriodSelected(years: Int, months: Int)
    
    func nextButtonDidTapped()
}
