//
//  SignUpPhotographerCareerPeriodPageViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/24/25.
//

import Combine
import OSLog

final class SignUpPhotographerCareerPeriodPageViewModel: SignUpPhotographerCareerPeriodPageViewModelProtocol {
    var delegate: SignUpViewModelDelegate?
    var currentPage: Int = 0
    var signUpSession: SignUpSession?
    
    @Published private(set) var years: Int = 0
    var yearsPublisher: AnyPublisher<Int, Never> {
        $years
            .map({ [self] years in
                self.signUpSession?.photoCareerYears = years
                return years
            })
            .eraseToAnyPublisher()
    }
    
    @Published private(set) var months: Int = 0
    var monthsPublisher: AnyPublisher<Int, Never> {
        $months
            .map({ [self] months in
                self.signUpSession?.photoCareerMonths = months
                return months
            })
            .eraseToAnyPublisher()
    }
    
    @Published var nextButtonEnabled: Bool = false
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }
    
    private var log = Logger.of("SignUpPhotographerCareerPeriodViewModel")
    
    func didPeriodSelected(years: Int, months: Int) {
        guard years >= 0 && months >= 0 else {
            log.error("years와 months는 음수가 될 수 없습니다.")
            return
        }
        
        nextButtonEnabled = !(years == 0 && months == 0)
        
        self.years = years
        self.months = months
    }
    
    func nextButtonDidTapped() {
        delegate?.goToNextPage(current: currentPage, session: signUpSession)
    }
}
