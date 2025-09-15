//
//  ViewModelsAssembly.swift
//  PicplzClient
//
//  Created by 임영택 on 9/12/25.
//

import Foundation
import Swinject

/// 뷰 컨트롤러 객체들을 등록한다.
final class ViewModelsAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MainViewModelProtocol.self) { resolver in
            let viewModel = MainViewModel()
            viewModel.logoutUseCase = resolver.resolve(LogoutUseCase.self)
            viewModel.getAuthInfoUseCase = resolver.resolve(GetAuthInfoUseCase.self)
            return viewModel
        }
        container.register(OnboardingViewModelProtocol.self) { _ in
            OnboardingViewModel()
        }
        container.register(SignUpNicknamePageViewModelProtocol.self) { _ in
            SignUpNicknamePageViewModel()
        }
        container.register(SignUpProfileImagePageViewModelProtocol.self) { _ in
            SignUpProfileImagePageViewModel()
        }
        container.register(SignUpMemberTypePageViewModelProtocol.self) { _ in
            SignUpMemberTypePageViewModel()
        }
        container.register(SignUpPhotographerCareerTypePageViewModelProtocol.self) { _ in
            SignUpPhotographerCareerTypePageViewModel()
        }
        container.register(SignUpPhotographerCareerPeriodPageViewModelProtocol.self) { _ in
            SignUpPhotographerCareerPeriodPageViewModel()
        }
        container.register(SignUpPhotographerThemesPageViewModelProtocol.self) { _ in
            SignUpPhotographerSpecializedThemesPageViewModel()
        }
        container.register(CustomerMapViewModelProtocol.self) { resolver in
            CustomerMapViewModel(
                getShortAddressUseCase: GetShortAddressUserCaseImpl(
                    locationService: resolver.resolve(LocationService.self)!
                )
            )
        }
        container.register(PhotographerDetailViewModel.self) { _ in PhotographerDetailViewModel() }
    }
}
