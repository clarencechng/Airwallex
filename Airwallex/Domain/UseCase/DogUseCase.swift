//
//  DogUseCase.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

protocol DogUseCaseProtocol {
    func getDogBreed() async throws -> Dog
}

final class DogUseCase: DogUseCaseProtocol {
    private let repository: DogRepositoryProtocol
    
    init(repository: DogRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDogBreed() async throws -> Dog {
        return try await repository.getDogBreed()
    }
}
