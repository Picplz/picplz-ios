//
//  SignUpMemberTypePageViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/17/25.
//

import Combine

protocol SignUpMemberTypePageViewModelProtocol: SignUpVIewModelProtocol {
    var selectedMemberType: SignUpSession.MemberType? { get }
    var selectedMemberTypePublisher: Published<SignUpSession.MemberType?>.Publisher { get }
    
    func didSelectedMemberType(for memberType: SignUpSession.MemberType?)
    func nextButtonDidTapped()
}
