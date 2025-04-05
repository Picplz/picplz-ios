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

class CustomerMapViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let headerView = MapHeaderView()
    private let mapView = MapView()
    private let refreshLocationButton = UIPicplzButton2(title: "내 위치 새로고침", image: UIImage(named: "ArrowRotateLeft")!)
    
    private var bottomSheetView: BottomSheetView!
    private let bottomSheetContentView = CustomerMapBottomSheetContentView()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private let log = Logger.of("CustomerMapViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
        let refreshButtonTapAction = UIAction { [weak self] _ in
            self?.getShortAddress(for: self?.locationManager.location)
        }
        refreshLocationButton.addAction(refreshButtonTapAction, for: .touchUpInside)

        // FIXME: Replace to real data
        mapView.photographerAvatarModels = [
            .init(name: "짱구", distance: 200, distanceUnit: .m, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "짱아", distance: 400, distanceUnit: .m, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "흰둥", distance: 800, distanceUnit: .m, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "훈", distance: 1000, distanceUnit: .m, active: false, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "철수", distance: 1.2, distanceUnit: .km, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
            .init(name: "원장", distance: nil, distanceUnit: nil, active: true, image: UIImage(named: "ProfileImagePlaceholder")!),
        ]
        
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            getShortAddress(for: locationManager.location)
        } else {
            print("\(String(describing: locationManager.authorizationStatus))")
        }
    }
    
    private func style() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .grey1
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        refreshLocationButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addressLabel.text = ""
        
        // TODO: refreshLocationButton styling

        mapView.backgroundColor = .clear
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.searchingMessageLabelView.alpha = 0
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        bottomSheetView = BottomSheetView(contentView: bottomSheetContentView)
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
        
        view.addSubview(refreshLocationButton)
        NSLayoutConstraint.activate([
            refreshLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            refreshLocationButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        // MARK: Bottom Sheet
        view.addSubview(bottomSheetView)
        NSLayoutConstraint.activate([
            bottomSheetView.topAnchor.constraint(equalTo: view.topAnchor),
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBlinkSearchingLable(count: 3)
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
        }) { _ in
            self.mapView.searchingMessageLabelView.isHidden = true // hide after animation
        }
    }
}

extension CustomerMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse,
           let currentLocation = manager.location {
            getShortAddress(for: currentLocation)
        } else {
            log.info("could not get current location because of status. status=\(String(describing: status))")
        }
    }
}

// TODO: migrate to ViewModel
extension CustomerMapViewController {
    func getShortAddress(for location: CLLocation?) {
        guard let location = location else {
            return
        }
        
        log.debug("current location: \(location)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko-KR")) { places, error in
            guard error == nil else {
                print("reverseGeocodeLocation error - \(error?.localizedDescription ?? "N/A")")
                return
            }
            
            if let places = places {
                guard let place = places.first else { return }
                
                self.log.debug("current place: \(place)")
                
                let debugDescription = place.debugDescription
                do {
                    let regex = /대한민국.*?,/
                    if let match = try regex.firstMatch(in: debugDescription) {
                        let matchedString = match.output // "대한민국 서울특별시 마포구 용강동 112-12,"
                        let addressComponents = matchedString.split(separator: " ")
                        if addressComponents.count >= 4 {
                            let shortAddress = "\(addressComponents[2]) \(addressComponents[3])"
                            self.headerView.addressLabel.text = shortAddress
                        }
                    } else {
                        self.headerView.addressLabel.text = "\(place.locality ?? "") \(place.subLocality ?? "")"
                    }
                } catch {
                    print("faild to parse debugDescription... error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct CustomerMapViewController_Preview: PreviewProvider {
    static var previews: some View {
        CustomerMapViewController().toPreview()
            .ignoresSafeArea()
    }
}
