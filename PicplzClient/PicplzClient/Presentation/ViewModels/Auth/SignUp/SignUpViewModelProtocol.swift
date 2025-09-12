//
//  SIgnUpVIewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/18/25.
//

import Foundation

protocol SignUpViewModelDelegate: AnyObject {
    func goToNextPage(current currentPage: Int, session signUpSession: SignUpSession?)
}

protocol SignUpVIewModelProtocol: AnyObject {
    var delegate: SignUpViewModelDelegate? { get set }
    var currentPage: Int { get set }
    var signUpSession: SignUpSession? { get set }

    var nextButtonEnabled: Bool { get }
    var nextButtonEnabledPublisher: Published<Bool>.Publisher { get }
}
