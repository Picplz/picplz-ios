//
//  SignUpPhotographerCareerTypePageViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import Combine

protocol SignUpPhotographerCareerTypePageViewModelProtocol: SignUpVIewModelProtocol {
    var havingCareer: Bool? { get }
    var havingCareerPublisher: Published<Bool?>.Publisher { get }

    var shouldShowPrompt: Bool { get }
    var shouldShowPromptPublisher: Published<Bool>.Publisher { get }

    var selectedCareerType: SignUpSession.CareerType? { get }
    var selectedCareerTypePublisher: AnyPublisher<SignUpSession.CareerType, Never> { get }

    func careerYesButtonTapped()
    func careerNoButtonTapped()
    func careerTypeSelected(for careerType: SignUpSession.CareerType)

    func nextButtonDidTapped()
}
