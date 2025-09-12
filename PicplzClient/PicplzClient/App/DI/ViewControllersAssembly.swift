//
//  ViewControllersAssembly.swift
//  PicplzClient
//
//  Created by 임영택 on 9/12/25.
// ®

import Foundation
import Swinject

/// 뷰 컨트롤러 객체들을 등록한다.
final class ViewControllersAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(OnboardingViewController.self) { resolver in
            let viewController = OnboardingViewController()
            viewController.viewModel = resolver.resolve(OnboardingViewModelProtocol.self)
            viewController.viewModel.loginUseCase = resolver.resolve(LoginUseCase.self)
            return viewController
        }
        container.register(MainViewController.self) { resolver in
            let viewController = MainViewController()
            viewController.viewModel = resolver.resolve(MainViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpNicknamePageViewController.self) { resolver in
            let viewController = SignUpNicknamePageViewController()
            viewController.viewModel = resolver.resolve(SignUpNicknamePageViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpProfileImagePageViewController.self) { resolver in
            let viewController = SignUpProfileImagePageViewController()
            viewController.viewModel = resolver.resolve(SignUpProfileImagePageViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpMemberTypePageViewController.self) { resolver in
            let viewController = SignUpMemberTypePageViewController()
            viewController.viewModel = resolver.resolve(SignUpMemberTypePageViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpPhotographerCareerTypePageViewController.self) { resolver in
            let viewController = SignUpPhotographerCareerTypePageViewController()
            viewController.viewModel = resolver.resolve(SignUpPhotographerCareerTypePageViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpPhotographerCareerPeriodViewController.self) { resolver in
            let viewController = SignUpPhotographerCareerPeriodViewController()
            viewController.viewModel = resolver.resolve(SignUpPhotographerCareerPeriodPageViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpPhotographerThemesPageViewController.self) { resolver in
            let viewController = SignUpPhotographerThemesPageViewController()
            viewController.viewModel = resolver.resolve(SignUpPhotographerThemesPageViewModelProtocol.self)
            return viewController
        }
        container.register(SignUpFinishViewController.self) { _ in
            SignUpFinishViewController()
        }
        container.register(CustomerViewController.self) { _ in
            CustomerViewController()
        }
        container.register(PhotographerViewController.self) { _ in
            PhotographerViewController()
        }
        container.register(CustomerMapViewController.self) { resolver in
            let viewController = CustomerMapViewController()
            viewController.viewModel = resolver.resolve(CustomerMapViewModelProtocol.self)
            return viewController
        }
        container.register(PhotographerDetailViewController.self) { resolver in
            let viewController = PhotographerDetailViewController()
            viewController.viewModel = resolver.resolve(PhotographerDetailViewModel.self)
            return viewController
        }
    }
}
