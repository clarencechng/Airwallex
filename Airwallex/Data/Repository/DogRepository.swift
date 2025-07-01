//
//  DogRepository.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

protocol DogRepositoryProtocol {
    func getDogBreed() async throws -> Dog
}

final class DogRepository: DogRepositoryProtocol {
    private let apiService: DogAPIServiceProtocol
    
    init(apiService: DogAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getDogBreed() async throws -> Dog {
        return try await apiService.fetchDogBreed()
    }
}
