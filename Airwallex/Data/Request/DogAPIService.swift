//
//  DogAPIService.swift
//  Airwallex
//
//  Created by Clarence Chng on 1/7/25.
//

import Foundation

protocol DogAPIServiceProtocol {
    func fetchDogBreed() async throws -> Dog
}

final class DogAPIService: DogAPIServiceProtocol {
    func fetchDogBreed() async throws -> Dog {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(Dog.self, from: data)
        return decodedData
    }
}
