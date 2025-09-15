//
//  SignUpMemberTypePageViewModel.swift
//  PicplzClient
//
//  Created by 임영택 on 2/20/25.
//

import Combine
import OSLog

final class SignUpMemberTypePageViewModel: SignUpMemberTypePageViewModelProtocol {
    weak var delegate: SignUpViewModelDelegate?
    var currentPage: Int = 0
    var signUpSession: SignUpSession? {
        didSet {
            guard let signUpSession = signUpSession else { return }
            selectedMemberType = signUpSession.memberType
        }
    }

    @Published private(set) var nextButtonEnabled = false
    var nextButtonEnabledPublisher: Published<Bool>.Publisher {
        $nextButtonEnabled
    }

    @Published private(set) var selectedMemberType: SignUpSession.MemberType? {
        didSet {
            guard let signUpSession = signUpSession else {
                log.warning("signUpSession is nil")
                return
            }

            signUpSession.memberType = selectedMemberType
            nextButtonEnabled = selectedMemberType != nil
        }
    }
    var selectedMemberTypePublisher: Published<SignUpSession.MemberType?>.Publisher {
        $selectedMemberType
    }

    private var log = Logger.of("SignUpMemberTypePageViewModel")

    func didSelectedMemberType(for memberType: SignUpSession.MemberType?) {
        selectedMemberType = memberType
    }

    func nextButtonDidTapped() {
        delegate?.goToNextPage(current: currentPage, session: signUpSession)
    }
}
