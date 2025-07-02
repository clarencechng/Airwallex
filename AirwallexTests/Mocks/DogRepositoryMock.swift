//
//  DogRepositoryMock.swift
//  AirwallexTests
//
//  Created by Clarence Chng on 2/7/25.
//

import Foundation
@testable import Airwallex

final class DogRepositoryMock: DogRepositoryProtocol {
    let apiService: DogAPIServiceProtocol

    init(apiService: DogAPIServiceProtocol) {
        self.apiService = apiService
    }

    func getDogBreed() async throws -> DogBreed {
        try await apiService.fetchDogBreed()
    }

    func getDogImageURL(breed: String, subType: String?) async throws -> String {
        try await apiService.fetchDogImageURL(breed: breed, subType: subType)
    }
}
