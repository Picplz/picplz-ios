//
//  GetShortAddressUseCase.swift
//  PicplzClient
//
//  Created by 임영택 on 4/5/25.
//

import Foundation
import Combine
import MapKit
import OSLog

protocol GetShortAddressUseCase {
    var shortAddressPublisher: AnyPublisher<String, Never> { get }
    func getShortAddress() async -> String?
}

final class GetShortAddressUserCaseImpl: GetShortAddressUseCase {
    private let locationService: LocationService
    
    @Published private var shortAddress: String?
    var shortAddressPublisher: AnyPublisher<String, Never> {
        $shortAddress
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private let log = Logger.of("GetShortAddressUserCaseImpl")
    
    init(locationService: LocationService) {
        self.locationService = locationService
        
        self.locationService.currentLocationPubisher
            .sink { location in
                Task.detached {
                    self.shortAddress = await self.getShortAddress(location: location)
                }
            }
            .store(in: &subscriptions)
    }
    
    func getShortAddress() async -> String? {
        guard let currentLocation = locationService.currentLocation else {
            return nil
        }
        
        return await getShortAddress(location: currentLocation)
    }
    
    private func getShortAddress(location: CLLocation) async -> String? {
        do {
            self.shortAddress = try await locationToShortAddress(location: location)
            return shortAddress
        } catch {
            return nil
        }
    }
    
    private func locationToShortAddress(location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        
        do {
            let places = try await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko-KR"))
            
            if let place = places.first {
                return try locationDebugDescriptionToShortAddress(place: place)
            } else {
                throw DomainError.internalError("첫번째 장소가 nil입니다")
            }
        } catch let error as DomainError {
            throw error
        } catch {
            throw DomainError.internalError("\(error)")
        }
    }
    
    private func locationDebugDescriptionToShortAddress(place: CLPlacemark) throws -> String {
        do {
            let regex = /대한민국.*?,/
            if let match = try regex.firstMatch(in: place.debugDescription) {
                let matchedString = match.output // "대한민국 서울특별시 마포구 용강동 112-12,"
                let addressComponents = matchedString.split(separator: " ")
                if addressComponents.count >= 4 {
                    return "\(addressComponents[2]) \(addressComponents[3])"
                } else {
                    throw DomainError.internalError("addressComponents 원소 수가 4보다 작습니다")
                }
            } else {
                return "\(place.locality ?? "") \(place.subLocality ?? "")"
            }
        } catch {
            self.log.error("faild to parse debugDescription... error: \(error.localizedDescription)")
            throw error
        }
    }
}
