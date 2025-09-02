//
//  TabBarItemCoordinator.swift
//  PicplzClient
//
//  Created by 임영택 on 3/10/25.
//

import Foundation
import UIKit

protocol TabBarItemCoordinator: Coordinator {
    var tabBarTitle: String { get }
    var tabBarImage: UIImage? { get }
    var tabBarSelectedImage: UIImage? { get }
    var tabBarIndex: Int { get }
}
