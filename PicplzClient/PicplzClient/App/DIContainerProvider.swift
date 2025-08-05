//
//  DIContainerProvider.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import Swinject
import os

final class DIContainerProvider {
    static let shared = DIContainerProvider()
    
    let container: Container
    
    private init() {
        self.container = DIContainerProvider.makeContainer()
        let logger = Logger.of("DIContainerProvider")
        logger.debug("DIContainerProvider init completed")
    }
    
    private static func makeContainer() -> Container {
        let container = Container()
        
        // MARK: Data
        container.register(AuthManaging.self) { _ in
            AuthManager(keychainStore: KeychainStore(), userDefaultHelper: UserDefaultsHelper())
        }
        .inObjectScope(.container)
        
        container.register(LocationService.self) { _ in
            LocationServiceImpl()
        }
        .inObjectScope(.container)
        
        container.register(AuthRequestable.self) { _ in
            AuthRequests()
        }
        
        container.register(CustomerRequestable.self) { _ in
            CustomerRequests()
        }
        
        // MARK: Domain
        container.register(LoginUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            let authReqeusts = r.resolve(AuthRequestable.self)!
            return LoginUseCaseImpl(authManaging: authManaging, authRequests: authReqeusts)
        }
        container.register(LogoutUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            return LogoutUseCaseImpl(authManaging: authManaging)
        }
        container.register(GetAuthInfoUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            return GetAuthInfoUseCaseImpl(authManaging: authManaging)
        }
        container.register(SendSignUpRequestUseCase.self) { r in
            let authManaging = r.resolve(AuthManaging.self)!
            let customerRequestable = r.resolve(CustomerRequestable.self)!
            return SendSignUpRequestUseCaseImpl(authManaging: authManaging, customerRequests: customerRequestable)
        }
        container.register(GetShortAddressUseCase.self) { r in
            let locationService = r.resolve(LocationService.self)!
            return GetShortAddressUserCaseImpl(locationService: locationService)
        }
        
        // MARK: Presentaion
        // MARK:              ...  View Models
        container.register(MainViewModelProtocol.self) { r in
            let viewModel = MainViewModel()
            viewModel.logoutUseCase = r.resolve(LogoutUseCase.self)
            viewModel.getAuthInfoUseCase = r.resolve(GetAuthInfoUseCase.self)
            return viewModel
        }
        container.register(OnboardingViewModelProtocol.self) { _ in OnboardingViewModel() }
        container.register(SignUpNicknamePageViewModelProtocol.self) { _ in SignUpNicknamePageViewModel() }
        container.register(SignUpProfileImagePageViewModelProtocol.self) { _ in SignUpProfileImagePageViewModel() }
        container.register(SignUpMemberTypePageViewModelProtocol.self) { _ in SignUpMemberTypePageViewModel() }
        container.register(SignUpPhotographerCareerTypePageViewModelProtocol.self) { _ in SignUpPhotographerCareerTypePageViewModel() }
        container.register(SignUpPhotographerCareerPeriodPageViewModelProtocol.self) { _ in SignUpPhotographerCareerPeriodPageViewModel() }
        container.register(SignUpPhotographerSpecializedThemesPageViewModelProtocol.self) { _ in SignUpPhotographerSpecializedThemesPageViewModel() }
        container.register(CustomerMapViewModelProtocol.self) { r in
            CustomerMapViewModel(
                getShortAddressUseCase: GetShortAddressUserCaseImpl(
                    locationService: r.resolve(LocationService.self)!
                )
            )
        }
        container.register(PhotographerDetailViewModel.self) { r in PhotographerDetailViewModel() }
        
        // MARK:              ...  View Controllers
        container.register(OnboardingViewController.self) { r in
            let vc = OnboardingViewController()
            vc.viewModel = r.resolve(OnboardingViewModelProtocol.self)
            vc.viewModel.loginUseCase = r.resolve(LoginUseCase.self)
            return vc
        }
        container.register(MainViewController.self) { r in
            let vc = MainViewController()
            vc.viewModel = r.resolve(MainViewModelProtocol.self)
            return vc
        }
        container.register(SignUpNicknamePageViewController.self) { r in
            let vc = SignUpNicknamePageViewController()
            vc.viewModel = r.resolve(SignUpNicknamePageViewModelProtocol.self)
            return vc
        }
        container.register(SignUpProfileImagePageViewController.self) { r in
            let vc = SignUpProfileImagePageViewController()
            vc.viewModel = r.resolve(SignUpProfileImagePageViewModelProtocol.self)
            return vc
        }
        container.register(SignUpMemberTypePageViewController.self) { r in
            let vc = SignUpMemberTypePageViewController()
            vc.viewModel = r.resolve(SignUpMemberTypePageViewModelProtocol.self)
            return vc
        }
        container.register(SignUpPhotographerCareerTypePageViewController.self) { r in
            let vc = SignUpPhotographerCareerTypePageViewController()
            vc.viewModel = r.resolve(SignUpPhotographerCareerTypePageViewModelProtocol.self)
            return vc
        }
        container.register(SignUpPhotographerCareerPeriodViewController.self) { r in
            let vc = SignUpPhotographerCareerPeriodViewController()
            vc.viewModel = r.resolve(SignUpPhotographerCareerPeriodPageViewModelProtocol.self)
            return vc
        }
        container.register(SignUpPhotographerSpecializedThemesPageViewController.self) { r in
            let vc = SignUpPhotographerSpecializedThemesPageViewController()
            vc.viewModel = r.resolve(SignUpPhotographerSpecializedThemesPageViewModelProtocol.self)
            return vc
        }
        container.register(SignUpFinishVIewController.self) { _ in
            return SignUpFinishVIewController()
        }
        container.register(CustomerViewController.self) { _ in
            return CustomerViewController()
        }
        container.register(PhotographerViewController.self) { _ in
            return PhotographerViewController()
        }
        container.register(CustomerMapViewController.self) { r in
            let vc = CustomerMapViewController()
            vc.viewModel = r.resolve(CustomerMapViewModelProtocol.self)
            return vc
        }
        container.register(PhotographerDetailViewController.self) { r in
            let vc = PhotographerDetailViewController()
            vc.viewModel = r.resolve(PhotographerDetailViewModel.self)
            return vc
        }
        return container
    }
}
