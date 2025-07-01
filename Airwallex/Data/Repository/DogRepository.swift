//
//  DogRepository.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

protocol DogRepositoryProtocol {
    func getDogBreed() async throws -> DogBreed
    func getDogImageURL(breed: String, subType: String?) async throws -> String
}

final class DogRepository: DogRepositoryProtocol {
    private let apiService: DogAPIServiceProtocol
    
    init(apiService: DogAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getDogBreed() async throws -> DogBreed {
        return try await apiService.fetchDogBreed()
    }
    
    func getDogImageURL(breed: String, subType: String?) async throws -> String {
        return try await apiService.fetchDogImageURL(breed: breed, subType: subType)
    }
}
