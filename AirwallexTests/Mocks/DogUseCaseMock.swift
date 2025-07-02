//
//  DogUseCaseMock.swift
//  AirwallexTests
//
//  Created by Clarence Chng on 2/7/25.
//

@testable import Airwallex

final class DogUseCaseMock: DogUseCaseProtocol {
    let repository: DogRepositoryProtocol
    
    init(repository: DogRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDogBreed() async throws -> DogBreed {
        try await repository.getDogBreed()
    }
    
    func getDogImageURL(breed: String, subType: String?) async throws -> String {
        try await repository.getDogImageURL(breed: breed, subType: subType)
    }
}
