//
//  DogUseCase.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

protocol DogUseCaseProtocol {
    func getDogBreed() async throws -> DogBreed
    func getDogImageURL(breed: String, subType: String?) async throws -> String
}

final class DogUseCase: DogUseCaseProtocol {
    private let repository: DogRepositoryProtocol
    
    init(repository: DogRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDogBreed() async throws -> DogBreed {
        return try await repository.getDogBreed()
    }
    
    func getDogImageURL(breed: String, subType: String?) async throws -> String {
        return try await repository.getDogImageURL(breed: breed, subType: subType)
    }
}
