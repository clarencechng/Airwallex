//
//  DogViewFactory.swift
//  Airwallex
//
//  Created by Clarence Chng on 2/7/25.
//

import Foundation

final class DogViewFactory {
    static func createDogView() -> DogView {
        let apiService = DogAPIService()
        let repository = DogRepository(apiService: apiService)
        let useCase = DogUseCase(repository: repository)
        return DogView(useCase: useCase)
    }
}
