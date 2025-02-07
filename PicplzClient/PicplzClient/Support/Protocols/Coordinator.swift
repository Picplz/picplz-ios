//
//  Coordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

protocol Coordinator: AnyObject {
    var childCoordinators : [Coordinator] { get set }
    func start()
}
