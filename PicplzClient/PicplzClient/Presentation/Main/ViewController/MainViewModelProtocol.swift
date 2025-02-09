//
//  MainViewModelProtocol.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func loggedOut()
}

protocol MainViewModelProtocol {
    var delegate: MainViewModelDelegate? { get set }
    func logoutButtonTapped()
}
