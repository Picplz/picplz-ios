//
//  SignUpViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/17/25.
//

import Combine
import Foundation

protocol SignUpProfileImagePageViewModelProtocol: SignUpVIewModelProtocol {
    var nextButtonTitle: String { get }
    var nextButtonTitlePublisher: Published<String>.Publisher { get }
    
    var informationLabelText: String { get }
    var informationLabelTextPublisher: Published<String>.Publisher { get }
    
    var userNickname: String { get }
    var userNicknamePublisher: Published<String>.Publisher { get }
    
    var profileImagePath: URL? { get }
    var profileImagePathPublisher: AnyPublisher<URL, Never> { get }
    
    func nextButtonDidTapped()
    func profileImageSelected(path: URL)
}
