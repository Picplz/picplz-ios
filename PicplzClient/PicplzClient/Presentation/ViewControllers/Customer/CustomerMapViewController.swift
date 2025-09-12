//
//  CustomerMapViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 3/12/25.
//

import UIKit
import SwiftUI
import CoreLocation
import MapKit
import OSLog
import Combine

class CustomerMapViewController: UIViewController {
    var viewModel: CustomerMapViewModelProtocol!

    private let scrollView = UIScrollView()
    private let headerView = MapHeaderView()
    private let mapView = MapView()
    private let refreshLocationButton = UIPicplzButton2(title: "내 위치 새로고침", image: UIImage(named: "ArrowRotateLeft")!)

    private var bottomSheetView: BottomSheetView!
    private let bottomSheetContentView = CustomerMapBottomSheetContentView()

    private var subscriptions: Set<AnyCancellable> = []

    private let log = Logger.of("CustomerMapViewController")

    private let maxYMargin: CGFloat = 24

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()

        let refreshButtonTapAction = UIAction { [weak self] _ in
            self?.viewModel.refreshButtonTapped()
        }
        refreshLocationButton.addAction(refreshButtonTapAction, for: .touchUpInside)

        // FIXME: Replace to real data
        mapView.photographerAvatarModels = [
            .init(name: "짱구", distance: 200, distanceUnit: .meters, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "짱아", distance: 400, distanceUnit: .meters, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "흰둥", distance: 800, distanceUnit: .meters, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "훈", distance: 1000, distanceUnit: .meters, active: false, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "철수", distance: 1.2, distanceUnit: .kilometers, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "원장", distance: nil, distanceUnit: nil, active: true, image: UIImage(named: "ProfileImagePlaceholder")!)
        ]

        bottomSheetContentView.onPhotographerSelected = { [weak self] photographerId in
            self?.viewModel.photographerSelected(id: photographerId)
        }

        bind()
        viewModel.onLoad()
    }

    private func style() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .ppGrey1

        headerView.translatesAutoresizingMaskIntoConstraints = false
        refreshLocationButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addressLabel.text = ""

        mapView.backgroundColor = .clear
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.searchingMessageLabelView.alpha = 0

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        bottomSheetView = BottomSheetView(
            contentView: bottomSheetContentView,
            prefereces: .getBasicPreferences(
                maxYOffset: safeFrame.minY + maxYMargin,
                minYOffset: safeFrame.maxY
            )
        )
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layout() {
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])

        view.addSubview(refreshLocationButton)
        NSLayoutConstraint.activate([
            refreshLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            refreshLocationButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        // MARK: Bottom Sheet
        view.addSubview(bottomSheetView)
        NSLayoutConstraint.activate([
            bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor),
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bind() {
        viewModel.shortAddressPublisher
            .receive(on: RunLoop.main)
            .sink { address in
                self.headerView.addressLabel.text = address
            }
            .store(in: &subscriptions)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // adjust offset on next loop
        // make scroll view's horizontal scroll half scrolled
        DispatchQueue.main.async {
            let scrollViewSize = self.scrollView.bounds.size
            let contentSize = self.scrollView.contentSize

            guard contentSize.width > 0 else { return }

            let offsetX = (contentSize.width - scrollViewSize.width) / 2

            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        }

        // MARK: Set minY, maxY to bottomSheet
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        bottomSheetView.minYOffset = safeFrame.maxY - maxYMargin // offset으로 따지므로 바꿔서 대입
        bottomSheetView.maxYOffset = safeFrame.minY
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBlinkSearchingLable(count: 3)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // FIXME: 애니메이션이 자연스럽지 않음
    func animateBlinkSearchingLable(count: Int) {
        mapView.searchingMessageLabelView.isHidden = false
        mapView.searchingMessageLabelView.alpha = 0
        UIView.animateKeyframes(withDuration: 3, delay: 0, options: [], animations: {
            for i in 0..<count {
                let relativeStart = Double(i) * (1.0 / 3.0) // 0 -> 1/3 -> 2/3
                let relativeDuration = 1.0 / 3.0

                // alpha 0 -> 1
                UIView.addKeyframe(withRelativeStartTime: relativeStart, relativeDuration: relativeDuration) {
                    self.mapView.searchingMessageLabelView.alpha = 1
                }

                // alpha 1 -> 0
                UIView.addKeyframe(withRelativeStartTime: relativeStart + relativeDuration, relativeDuration: relativeDuration) {
                    self.mapView.searchingMessageLabelView.alpha = 0
                }
            }
        }, completion: { _ in
            self.mapView.searchingMessageLabelView.isHidden = true // hide after animation
        })
    }
}

struct CustomerMapViewController_Preview: PreviewProvider {
    static var previews: some View {
        let viewController = CustomerMapViewController()
        viewController.viewModel = CustomerMapViewModel(
            getShortAddressUseCase: GetShortAddressUserCaseImpl(locationService: LocationServiceImpl())
        )

        return viewController.toPreview()
            .ignoresSafeArea()
    }
}
