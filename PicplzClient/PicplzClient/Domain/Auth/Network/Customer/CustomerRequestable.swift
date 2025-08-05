//
//  CustomerRequestable.swift
//  PicplzClient
//
//  Created by 임영택 on 8/5/25.
//

import Foundation

protocol CustomerRequestable {
    func create(registerDto: CustomerRegisterDTO) async throws
}
